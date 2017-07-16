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

function GM:CreateSettingsPanel()

	local f = self:CreateFrame( "Settings", 300, 300 );

	local p1 = self:CreatePanel( f, TOP, 0, 24 );
	p1:DockMargin( 10, 10, 10, 10 );
		local c = self:CreateCheckbox( p1, LEFT, 24, 0, function( self, checked )
			GAMEMODE:SetSetting( "music", self:GetChecked() and 1 or 0 );
		end );
		c:SetChecked( self:GetSetting( "music", 1 ) == 1 );
		self:CreateLabel( p1, FILL, "COI 18", I18( "setting_play_music" ), 4 );

	local p1 = self:CreatePanel( f, TOP, 0, 24 );
	p1:DockMargin( 10, 10, 10, 10 );
		local c = self:CreateCheckbox( p1, LEFT, 24, 0, function( self, checked )
			GAMEMODE:SetSetting( "warning", self:GetChecked() and 1 or 0 );
		end );
		c:SetChecked( self:GetSetting( "warning", 1 ) == 1 );
		self:CreateLabel( p1, FILL, "COI 18", I18( "setting_last_min_warning" ), 4 );

	local p1 = self:CreatePanel( f, TOP, 0, 24 );
	p1:DockMargin( 10, 10, 10, 10 );
		local c = self:CreateCheckbox( p1, LEFT, 24, 0, function( self, checked )
			GAMEMODE:SetSetting( "camroll", self:GetChecked() and 1 or 0 );
		end );
		c:SetChecked( self:GetSetting( "camroll", 1 ) == 1 );
		self:CreateLabel( p1, FILL, "COI 18", I18( "setting_cam_roll" ), 4 );

end