GM.Languages = RequireDir( "i18" );

local l = GetConVar( "gmod_language" ):GetString();

if( l and GM.Languages[l] ) then
	GM.Language = GM.Languages[l];
else
	GM.Language = GM.Languages["en"];
end

function I18( str, ... )

	local tabReplace = { ... };
	local s;
	if( GAMEMODE ) then
		s = GAMEMODE.Language[str] or str;
	elseif( GM ) then
		s = GM.Language[str] or str;
	end

	for i = 1, 9 do

		if( tabReplace[i] ) then
			s = string.Replace( s, "$" .. i, tabReplace[i] ); -- hello, it is $me => hello, it is disseminate
			s = string.Replace( s, "@" .. i, string.ToMinutesSeconds( tabReplace[i] ) ); -- hello, it is @var => hello, it is 10:03
		end

	end

	return s;

end
