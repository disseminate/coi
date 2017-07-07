local meta = FindMetaTable( "Player" );

GM.CamPos = {
	["coi_test"] = {
		Vector( 1475, 687, 279 ),
		Angle( 7, -122, 0 )
	}
};

function GM:InitPostEntity()

	self:InitializeTeams();

	self:CheckNavmesh();

end

function meta:SyncMapData()

	net.Start( "nMapData" );
		net.WriteVector( GAMEMODE.CamPos[game.GetMap()][1] );
		net.WriteAngle( GAMEMODE.CamPos[game.GetMap()][2] );
	net.Send( self );

end
util.AddNetworkString( "nMapData" );