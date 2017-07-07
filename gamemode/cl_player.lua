local function nPlayers( len )

	local n = net.ReadUInt( 7 );

	for i = 1, n do

		local ply = net.ReadEntity();
		ply.Joined = net.ReadBool();
		ply.HasMoney = net.ReadBool();
		ply.Safe = net.ReadBool();

	end

end
net.Receive( "nPlayers", nPlayers );

function GM:PrePlayerDraw( ply )
	
	if( !ply.Joined ) then return true end

	if( ply.Safe or self:GetState() == STATE_PREGAME ) then

		local truck = ply:GetTruck();

		if( truck ) then
			
			local p0 = truck:GetPos();

			local n = 1;
			for k, v in pairs( team.GetPlayers( ply:Team() ) ) do
				if( v == ply ) then
					n = k;
					break;
				end
			end

			local x = 20 - ( ( n - 1 ) % 5 ) * 16;
			local y = 24;
			if( n % 11 >= 6 ) then
				y = -24;
			end
			local z = -5;

			local ang = truck:GetAngles();
			if( n % 11 >= 6 ) then
				ang:RotateAroundAxis( truck:GetUp(), -90 );
			else
				ang:RotateAroundAxis( truck:GetUp(), 90 );
			end

			local rpos = p0 + truck:GetForward() * x + truck:GetRight() * y + truck:GetUp() * z;
			ply:SetPos( rpos );
			ply:SetRenderOrigin( rpos );
			ply:SetRenderAngles( ang );

		end

	end

end

local function nSetTeamAuto( len )

	local t = net.ReadUInt( 16 );
	chat.AddText( GAMEMODE:GetSkin().COLOR_WHITE, "You have joined the ", team.GetColor( t ), team.GetName( t ), GAMEMODE:GetSkin().COLOR_WHITE, " team." );

end
net.Receive( "nSetTeamAuto", nSetTeamAuto );

local function nSetTeamAutoRebalance( len )

	local t = net.ReadUInt( 16 );
	chat.AddText( GAMEMODE:GetSkin().COLOR_WHITE, "Teams have been rebalanced. You have joined the ", team.GetColor( t ), team.GetName( t ), GAMEMODE:GetSkin().COLOR_WHITE, " team." );

end
net.Receive( "nSetTeamAutoRebalance", nSetTeamAutoRebalance );

local function nSetHasMoney( len )

	local ply = net.ReadEntity();
	local has = net.ReadBool();

	ply.HasMoney = has;

end
net.Receive( "nSetHasMoney", nSetHasMoney );

local function nSetSafe( len )

	local ply = net.ReadEntity();
	local safe = net.ReadBool();

	ply.Safe = safe;

end
net.Receive( "nSetSafe", nSetSafe );

function GM:NetworkEntityCreated( ent )

	if( ent and ent:IsValid() ) then

		if( ent:IsPlayer() and ent:IsBot() ) then

			ent.Joined = true;

		end

		if( self.Teams and ent:GetClass() == "coi_truck" and #ents.FindByClass( "coi_truck" ) == #self.Teams ) then

			self:ResetMapTrucks();

		end

	end

end

local function nUnconscious( len )

	local ply = net.ReadEntity();

	ply.Unconscious = true;
	ply:CollisionRulesChanged();

	ply.UnconsciousTime = CurTime();
	if( ply == LocalPlayer() ) then
		ply.Consciousness = 30;
	end

end
net.Receive( "nUnconscious", nUnconscious );

local function nSetConsciousness( len )

	local amt = net.ReadUInt( 7 );
	LocalPlayer().Consciousness = amt;

end
net.Receive( "nSetConsciousness", nSetConsciousness );

function GM:ConsciousnessThink()

	if( !LocalPlayer().NextConsciousRecover ) then
		LocalPlayer().NextConsciousRecover = CurTime();
	end

	if( !LocalPlayer().Consciousness ) then
		LocalPlayer().Consciousness = 100;
	end

	if( CurTime() >= LocalPlayer().NextConsciousRecover ) then

		LocalPlayer().NextConsciousRecover = CurTime() + 1;
		LocalPlayer().Consciousness = math.Clamp( LocalPlayer().Consciousness + 5, 0, 100 );

	end

	for _, v in pairs( player.GetAll() ) do

		if( v.Unconscious and CurTime() >= v.UnconsciousTime + 5 ) then
			v.Unconscious = false;
			v:CollisionRulesChanged();
		end

	end

end