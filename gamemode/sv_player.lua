local meta = FindMetaTable( "Player" );

function GM:PlayerLoadout( ply )

	ply:Loadout();

end

local function nJoin( len, ply )

	if( !ply.Joined ) then

		ply.Joined = true;

		ply:SetTeamAuto();
		ply:SetColorToTeam();

		net.Start( "nJoin" );
			net.WriteEntity( ply );
		net.Broadcast();

		ply:SpawnAtTruck();

		ply:InitializeSQL();

		ply:SendPlayers();
		ply:SendState();
		
		if( #player.GetJoined() == 1 ) then
			GAMEMODE:ResetState();
		end

	end

end
net.Receive( "nJoin", nJoin );
util.AddNetworkString( "nJoin" );

function GM:PlayerInitialSpawn( ply )

	self.BaseClass:PlayerInitialSpawn( ply );

	ply.Joined = false;

	ply:SetTeam( TEAM_UNJOINED );
	ply:CollisionRulesChanged();

end

function GM:PlayerSpawn( ply )

	if( !ply.Synced ) then

		ply.Synced = true;

		ply:SyncMapData();

	end

	player_manager.SetPlayerClass( ply, "coi" );

	ply:UnSpectate();

	ply:SetupHands();

	player_manager.OnPlayerSpawn( ply );
	player_manager.RunClass( ply, "Spawn" );
	hook.Call( "PlayerSetModel", GAMEMODE, ply );
	hook.Call( "PlayerLoadout", GAMEMODE, ply );

	ply:SetCustomCollisionCheck( true );

	if( ply:IsBot() and !ply.Joined ) then

		ply.Joined = true;

		ply:SetTeamAuto();
		ply:SetColorToTeam();

		net.Start( "nJoin" );
			net.WriteEntity( ply );
		net.Broadcast();

		ply:SpawnAtTruck();

		if( #player.GetJoined() == 1 ) then
			GAMEMODE:ResetState();
		end

	end

	ply:SetColorToTeam();
	ply:SpawnAtTruck();

	ply.Consciousness = 100;
	net.Start( "nSetConsciousness" );
		net.WriteUInt( 100, 7 );
	net.Send( ply );

end

function meta:SendPlayers()

	net.Start( "nPlayers" );
		net.WriteUInt( #player.GetAll(), 7 );
		for _, v in pairs( player.GetAll() ) do

			net.WriteEntity( v );
			net.WriteBool( v.Joined );
			net.WriteBool( v.HasMoney );
			net.WriteBool( v.Safe );

		end
	net.Send( self );

	for _, v in pairs( player.GetAll() ) do

		if( v.Cloaked ) then

			net.Start( "nCloak" );
				net.WriteEntity( v );
			net.Send( self );

		end

	end

end
util.AddNetworkString( "nPlayers" );

function meta:SetTeamAuto( noMsg )

	local teams = GAMEMODE.Teams;

	local amt = math.huge;
	local t = -1;

	for k, v in RandomPairs( teams ) do

		if( team.NumPlayers( v ) < amt ) then
			t = v;
			amt = team.NumPlayers( v );
		end

	end

	if( t > -1 ) then

		self:SetTeam( t );
		self:CollisionRulesChanged();

		if( !noMsg ) then

			net.Start( "nSetTeamAuto" );
				net.WriteUInt( t, 16 );
			net.Send( self );

		end

	end

end
util.AddNetworkString( "nSetTeamAuto" );

function meta:SetColorToTeam()

	local col = team.GetColor( self:Team() );
	self:SetPlayerColor( Vector( col.r / 255, col.g / 255, col.b / 255 ) );

end

function meta:SpawnAtTruck()

	local pos = self:GetSpawnPos();
	if( pos ) then
		self:SetPos( pos );
	end

end

function GM:RebalanceTeams()

	for _, v in pairs( player.GetAll() ) do

		v:SetTeam( TEAM_UNJOINED );

	end

	for _, v in pairs( player.GetAll() ) do

		v:SetTeamAuto( true );
		v:SetColorToTeam();

		net.Start( "nSetTeamAutoRebalance" );
			net.WriteUInt( v:Team(), 16 );
		net.Send( v );

	end

end
util.AddNetworkString( "nSetTeamAutoRebalance" );

local function nJoinTeam( len, ply )

	local t = net.ReadUInt( 16 );
	
	if( !GAMEMODE:CanChangeTeam( ply:Team(), t ) ) then return end

	ply:SetTeam( t );
	ply:CollisionRulesChanged();
	ply:SetColorToTeam();
	ply:SpawnAtTruck();

end
net.Receive( "nJoinTeam", nJoinTeam );
util.AddNetworkString( "nJoinTeam" );

function GM:PlayerTakeMoney( ply, ent )

	if( !ply.HasMoney ) then
		
		ply.HasMoney = true;
		net.Start( "nSetHasMoney" );
			net.WriteEntity( ply );
			net.WriteBool( true );
		net.Broadcast();

	end

end
util.AddNetworkString( "nSetHasMoney" );

function GM:KeyPress( ply, key )

	if( ply.HasMoney and key == IN_ATTACK2 and self:GetState() == STATE_GAME ) then

		ply:DropMoney( true );

	end

	if( ply.Safe and key == IN_USE and self:InRushPeriod() ) then
		
		ply.Safe = false;
		ply.LastUnsafe = CurTime();
		net.Start( "nSetSafe" );
			net.WriteEntity( ply );
			net.WriteBool( false );
		net.Broadcast();

	end

end

function meta:DropMoney( thrown, ao )

	self.HasMoney = false;
	net.Start( "nSetHasMoney" );
		net.WriteEntity( self );
		net.WriteBool( false );
	net.Broadcast();
	
	self:EmitSound( Sound( "coi/coin.wav" ), 100, math.random( 80, 120 ) );

	ao = ao or self:GetAimVector();

	local bag = ents.Create( "coi_money" );
	bag:SetPos( self:GetShootPos() + ao * 32 );
	bag:SetAngles( Angle( math.Rand( -180, 180 ), math.Rand( -180, 180 ), math.Rand( -180, 180 ) ) );
	bag.Owner = self;
	bag:SetDropped( true );
	bag:SetThrown( thrown );
	bag:Spawn();
	bag:Activate();
	
end

function GM:Loadout( b )

	for _, v in pairs( player.GetAll() ) do

		v:Loadout( b );

	end

end

function meta:Loadout( first )

	self:CheckInventory();

	self:Give( "weapon_coi_fists" );

	if( self.PrimaryLoadout ) then
		local item = self.Inventory[self.PrimaryLoadout];
		local i = GAMEMODE.Items[item.ItemClass];
		if( i.SWEP ) then
			self:Give( i.SWEP );
		end
		if( i.OnGive and first ) then
			i.OnGive( self );
		end
	end

	if( self.SecondaryLoadout ) then
		local item = self.Inventory[self.SecondaryLoadout];
		local i = GAMEMODE.Items[item.ItemClass];
		if( i.SWEP ) then
			self:Give( i.SWEP );
		end
		if( i.OnGive and first ) then
			i.OnGive( self );
		end
	end

	local w = self:GetActiveWeapon();
	if( w and w:IsValid() and w != NULL ) then

		if( w.NoDraw ) then

			for _, v in pairs( self:GetWeapons() ) do

				if( !v.NoDraw ) then
					self:SelectWeapon( v:GetClass() );
					break;
				end

			end

		end

	end

end

function GM:EntityTakeDamage( ply, dmg )

	local a = dmg:GetAttacker();
	local i = dmg:GetInflictor();

	if( ply:IsPlayer() ) then

		if( a and a:IsValid() and a:IsPlayer() and a:Team() == ply:Team() ) then
			return true;
		end

		if( ply.Unconscious ) then
			return true;
		end

		local consc = false;
		local fattac = nil;

		if( i and i:IsValid() ) then
			
			if( i:GetClass() == "coi_money" ) then

				consc = true;
				dmg:SetDamage( 100 );
				fattac = i.Owner;

			elseif( i:GetClass() == "coi_taser" ) then

				consc = true;
				fattac = i.Owner;

			end

		end

		if( consc ) then

			if( !ply.Consciousness ) then
				ply.Consciousness = 100;
			end

			ply.Consciousness = math.Clamp( ply.Consciousness - dmg:GetDamage(), 0, 100 );

			if( ply.Consciousness <= 0 ) then

				ply.Unconscious = true;
				ply.UnconsciousTime = CurTime();
				ply.Consciousness = 30;

				if( fattac and fattac:IsValid() ) then

					fattac.Knockouts = ( fattac.Knockouts or 0 ) + 1;

				end

				ply:Freeze( true );

				ply:CollisionRulesChanged();

				net.Start( "nUnconscious" );
					net.WriteEntity( ply );
				net.Broadcast();

				if( ply.HasMoney ) then

					local ang = ply:GetAngles();
					ang.p = 20;
					ang.r = 0;

					ply:DropMoney( true, ang:Forward() );

				end

			else

				net.Start( "nSetConsciousness" );
					net.WriteUInt( ply.Consciousness, 7 );
				net.Send( ply );

			end

			return true;

		elseif( a and a:IsValid() and a:IsPlayer() ) then

			local dmgScale = 1 - math.Clamp( #player.GetJoined() / 20, 0, 1 ) * 0.5;
			dmg:ScaleDamage( dmgScale );

		end

	end

end
util.AddNetworkString( "nUnconscious" );
util.AddNetworkString( "nSetConsciousness" );

function GM:ConsciousnessThink()

	for _, v in pairs( player.GetAll() ) do

		if( !v.NextConsciousRecover ) then
			v.NextConsciousRecover = CurTime();
		end

		if( !v.Consciousness ) then
			v.Consciousness = 100;
		end

		if( CurTime() >= v.NextConsciousRecover ) then

			v.NextConsciousRecover = CurTime() + 1;
			v.Consciousness = math.Clamp( v.Consciousness + 5, 0, 100 );

		end

		if( v.Unconscious and CurTime() >= v.UnconsciousTime + 5 ) then
			v.Unconscious = false;
			v:Freeze( false );
			v:CollisionRulesChanged();
		end

	end

end

function GM:PlayerDeath( ply, inflictor, attacker )

	self.BaseClass:PlayerDeath( ply, inflictor, attacker );

	if( ply.HasMoney ) then

		local ang = ply:GetAngles();
		ang.p = 20;
		ang.r = 0;

		ply:DropMoney( true, ang:Forward() );

	end

	if( attacker and attacker:IsValid() and attacker:IsPlayer() ) then

		attacker.Kills = ( attacker.Kills or 0 ) + 1;

	end

end

function meta:DebugGiveMoney()

	self.HasMoney = true;
	net.Start( "nSetHasMoney" );
		net.WriteEntity( self );
		net.WriteBool( true );
	net.Broadcast();

end

local function nWipePlayer( len, ply )

	ply.Money = 0;
	ply.Inventory = { };

	ply:WipeSQL();
	
end
net.Receive( "nWipePlayer", nWipePlayer );
util.AddNetworkString( "nWipePlayer" );

function GM:ScalePlayerDamage( ply, hg, dmg )

	self.BaseClass:ScalePlayerDamage( ply, hg, dmg );

end

function GM:GetFallDamage( ply, speed )

	return 0;

end
