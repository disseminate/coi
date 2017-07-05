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

		local teams = self.Teams;
		if( !teams ) then return end
		if( !teams[ply:Team()] ) then return end
		if( !teams[ply:Team()].Truck or !teams[ply:Team()].Truck:IsValid() ) then return end

		local truck = teams[ply:Team()].Truck;
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

		ply:SetPos( p0 + truck:GetForward() * x + truck:GetRight() * y + truck:GetUp() * z );
		ply:SetRenderAngles( ang );

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

local function nSetMoney( len )

	local ply = net.ReadEntity();
	local has = net.ReadBool();

	ply.HasMoney = has;

end
net.Receive( "nSetMoney", nSetMoney );

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