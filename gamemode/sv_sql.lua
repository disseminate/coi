local meta = FindMetaTable( "Player" );

sql.Query( "CREATE TABLE IF NOT EXISTS coi_players ( ID INTEGER PRIMARY KEY, SteamID TEXT, Money INTEGER )" );
sql.Query( "CREATE TABLE IF NOT EXISTS coi_inventory ( ID INTEGER PRIMARY KEY, PlayerID INTEGER, ItemClass TEXT )" );

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

	self.Inventory = { };

	local items = sql.Query( "SELECT * FROM coi_inventory WHERE PlayerID = " .. self.ID .. ";" );

	if( items ) then
		
		for _, v in pairs( items ) do

			table.insert( self.Inventory, v.ItemClass );

		end

		net.Start( "nSetInventory" );
			net.WriteUInt( #self.Inventory, 8 );
			for _, v in pairs( self.Inventory ) do
				net.WriteString( v );
			end
		net.Send( self );

	else

		net.Start( "nSetInventory" );
			net.WriteUInt( 0, 8 );
		net.Send( self );

	end

end
util.AddNetworkString( "nSetInventory" );
util.AddNetworkString( "nSetMoney" );

function meta:SQLAddItem( item )

	local exists = tonumber( sql.QueryValue( "SELECT COUNT(*) FROM coi_inventory WHERE PlayerID = " .. self.ID .. " AND ItemClass = " .. sql.SQLStr( item ) .. ";" ) ) >= 1;
	if( !exists ) then

		sql.Query( "INSERT INTO coi_inventory ( PlayerID, ItemClass ) VALUES ( " .. self.ID .. ", " .. sql.SQLStr( item ) .. " );" );

	end

end