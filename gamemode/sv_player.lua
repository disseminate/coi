local meta = FindMetaTable( "Player" );

function GM:PlayerLoadout( ply )

	

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

	ply:SendPlayers();
	ply:SendState();

	ply:SetTeam( TEAM_UNJOINED );

end

function GM:PlayerSpawn( ply )

	player_manager.SetPlayerClass( ply, "coi" );

	ply:UnSpectate();

	ply:SetupHands();

	player_manager.OnPlayerSpawn( ply );
	player_manager.RunClass( ply, "Spawn" );
	hook.Call( "PlayerSetModel", GAMEMODE, ply );

	ply:SetCustomCollisionCheck( true );

	if( ply:IsBot() ) then

		ply.Joined = true;

		ply:SetTeamAuto();
		ply:SetColorToTeam();

		net.Start( "nJoin" );
			net.WriteEntity( ply );
		net.Broadcast();

	end

	ply:SetColorToTeam();
	ply:SpawnAtTruck();

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

end
util.AddNetworkString( "nPlayers" );

function meta:SetTeamAuto( noMsg )

	local teams = GAMEMODE.Teams;

	local amt = math.huge;
	local t = -1;

	for k, v in pairs( teams ) do

		if( team.NumPlayers( k ) < amt ) then
			t = k;
			amt = team.NumPlayers( k );
		end

	end

	if( t > -1 ) then

		self:SetTeam( t );

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

	if( !GAMEMODE.Teams ) then return end
	if( !GAMEMODE.Teams[self:Team()] ) then return end
	if( !GAMEMODE.Teams[self:Team()].SpawnPos ) then return end

	local t = GAMEMODE.Teams[self:Team()].SpawnPos;
	self:SetPos( t );

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
	ply:SetColorToTeam();
	ply:SpawnAtTruck();

end
net.Receive( "nJoinTeam", nJoinTeam );
util.AddNetworkString( "nJoinTeam" );

function GM:PlayerTakeMoney( ply, ent )

	if( !ply.HasMoney ) then
		
		ply.HasMoney = true;
		net.Start( "nSetMoney" );
			net.WriteEntity( ply );
			net.WriteBool( true );
		net.Broadcast();

	end

end
util.AddNetworkString( "nSetMoney" );

function GM:KeyPress( ply, key )

	if( ply.HasMoney and key == IN_ATTACK2 and self:GetState() == STATE_GAME ) then

		ply:DropMoney( true );

	end

	if( ply.Safe and key == IN_USE and self:InRushPeriod() ) then
		
		ply.Safe = false;
		net.Start( "nSetSafe" );
			net.WriteEntity( ply );
			net.WriteBool( false );
		net.Broadcast();

	end

end

function meta:DropMoney( thrown )

	self.HasMoney = false;
	net.Start( "nSetMoney" );
		net.WriteEntity( self );
		net.WriteBool( false );
	net.Broadcast();
	
	self:EmitSound( Sound( "coi/coin.wav" ), 100, math.random( 80, 120 ) );

	local bag = ents.Create( "coi_money" );
	bag:SetPos( self:GetShootPos() + self:GetAimVector() * 32 );
	bag:SetAngles( Angle( math.Rand( -180, 180 ), math.Rand( -180, 180 ), math.Rand( -180, 180 ) ) );
	bag.Owner = self;
	bag:SetDropped( true );
	bag:SetThrown( thrown );
	bag:Spawn();
	bag:Activate();

end