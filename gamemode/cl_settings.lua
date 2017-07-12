function GM:SetSetting( key, val )

	cookie.Set( "coi_setting_" .. key, val );

end

function GM:GetSetting( key, default )

	local val = cookie.GetString( "coi_setting_" .. key );
	if( !val ) then
		return default;
	end

	if( tonumber( val ) ) then
		return tonumber( val );
	end

	return val;

end