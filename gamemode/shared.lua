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