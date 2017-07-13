local meta = FindMetaTable( "Player" );

sql.Begin();
sql.Query( "CREATE TABLE IF NOT EXISTS coi_players ( ID INTEGER PRIMARY KEY, SteamID TEXT, Money INTEGER )" );
sql.Query( "CREATE TABLE IF NOT EXISTS coi_inventory ( ID INTEGER PRIMARY KEY, PlayerID INTEGER, ItemClass TEXT, X INTEGER, Y INTEGER )" );
sql.Commit();

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

			self.Inventory[tonumber( v.ID )] = {
				ItemClass = v.ItemClass,
				X = tonumber( v.X ),
				Y = tonumber( v.Y )
			};

		end

		net.Start( "nSetInventory" );
			net.WriteUInt( #self.Inventory, 8 );
			for k, v in pairs( self.Inventory ) do
				net.WriteUInt( k, 16 );
				net.WriteString( v.ItemClass );
				net.WriteUInt( v.X, 6 );
				net.WriteUInt( v.Y, 6 );
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

function meta:SQLAddItem( item, x, y )

	local exists = tonumber( sql.QueryValue( "SELECT COUNT(*) FROM coi_inventory WHERE PlayerID = " .. self.ID .. " AND ItemClass = " .. sql.SQLStr( item ) .. ";" ) ) >= 1;
	if( !exists ) then

		local r = sql.Query( "INSERT INTO coi_inventory ( PlayerID, ItemClass, X, Y ) VALUES ( " .. self.ID .. ", " .. sql.SQLStr( item ) .. ", " .. x .. ", " .. y .. " ); SELECT last_insert_rowid() AS id FROM coi_inventory LIMIT 1;" );
		return tonumber( r[1].id );

	end

end

function meta:SQLDeleteItem( item )

	sql.Query( "DELETE FROM coi_inventory WHERE PlayerID = " .. self.ID .. " AND ID = " .. item .. ";" )

end

function meta:SQLMoveInventory( id, x, y )

	sql.Query( "UPDATE coi_inventory SET X = " .. x .. ", Y = " .. y .. " WHERE ID = " .. id .. ";" );

end

function meta:WipeSQL()

	sql.Begin();
		sql.Query( "DELETE FROM coi_inventory WHERE PlayerID = " .. self.ID .. ";" );
		sql.Query( "UPDATE coi_players SET Money = 0 WHERE ID = " .. self.ID .. ";" );
	sql.Commit();

end