DeriveGamemode( "base" );

function RequireDir( dir )

	local files = file.Find( GM.Folder .. "/gamemode/" .. dir .. "/*.lua", "GAME" );
	if( CLIENT ) then
		files = file.Find( GM.FolderName .. "/gamemode/" .. dir .. "/*.lua", "LUA" );
	end

	EXPORTS = { };

	for _, v in pairs( files ) do

		include( dir .. "/" .. v );

		if( SERVER ) then

			AddCSLuaFile( dir .. "/" .. v );

		end

	end

	return EXPORTS;

end

function Alpha( col, amt )

	if( amt == 1 ) then return col end
	
	local col = table.Copy( col );

	col.a = col.a * amt;

	return col;

end

net.OldIncoming = net.OldIncoming or net.Incoming;

function net.Incoming( len, ply )

	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )
	
	if ( !strName ) then return end
	
	local func = net.Receivers[ strName:lower() ]
	if ( !func ) then return end

	len = len - 16

	if( SERVER ) then

		MsgC( Color( 100, 100, 255 ), "[SERVER] " );
		
	else

		MsgC( Color( 255, 255, 100 ), "[CLIENT] " );

	end

	MsgC( Color( 255, 255, 255 ), strName, Color( 128, 128, 128 ), " (" .. len .. " bits)\n" );
	
	func( len, ply )

end