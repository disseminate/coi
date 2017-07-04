local function nPlayers( len )

	local n = net.ReadUInt( 7 );

	for i = 1, n do

		local ply = net.ReadEntity();
		ply.Joined = net.ReadBool();

	end

end
net.Receive( "nPlayers", nPlayers );

function GM:PrePlayerDraw( ply )

	if( !ply.Joined ) then return true end

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
