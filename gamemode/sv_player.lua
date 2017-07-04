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
	ply:SetCustomCollisionCheck( true );

	if( ply:IsBot() ) then

		ply.Joined = true;

		ply:SetTeamAuto();
		ply:SetColorToTeam();

		net.Start( "nJoin" );
			net.WriteEntity( ply );
		net.Broadcast();

	else

		ply:SetTeam( TEAM_UNJOINED );

	end

end

function meta:SendPlayers()

	net.Start( "nPlayers" );
		net.WriteUInt( #player.GetAll(), 7 );
		for _, v in pairs( player.GetAll() ) do

			net.WriteEntity( v );
			net.WriteBool( v.Joined );

		end
	net.Send( self );

end
util.AddNetworkString( "nPlayers" );

function meta:SetTeamAuto( noMsg )

	local trucks = GAMEMODE.Trucks;

	local amt = math.huge;
	local t = -1;

	for k, v in pairs( trucks ) do

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

function GM:AreTeamsUnbalanced()

	return !self:CanChangeTeam();

end

function GM:CanChangeTeam( cur, targ )

	-- TODO
	return true;

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