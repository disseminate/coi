local meta = FindMetaTable( "Player" );

sql.Query( "CREATE TABLE IF NOT EXISTS coi_players ( ID INTEGER PRIMARY KEY, SteamID TEXT, Money INTEGER )" );

function meta:InitializeSQL()

	local exists = tonumber( sql.QueryValue( "SELECT COUNT(*) FROM coi_players WHERE SteamID = " .. sql.SQLStr( self:SteamID() ) .. ";" ) ) >= 1;
	if( !exists ) then

		sql.Query( "INSERT INTO coi_players ( SteamID, Money ) VALUES ( " .. sql.SQLStr( self:SteamID() ) .. ", 0 );" );

	end

	self:LoadSQL();

end

function meta:LoadSQL()

	local row = sql.Query( "SELECT * FROM coi_players WHERE SteamID = " .. sql.SQLStr( self:SteamID() ) .. ";" )[1];

	self.ID = tonumber( row.ID );
	self.Money = tonumber( row.Money );

	net.Start( "nSetMoney" );
		net.WriteUInt( self.Money, 32 );
	net.Send( self );

end

util.AddNetworkString( "nSetMoney" );