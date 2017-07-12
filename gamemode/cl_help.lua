function GM:ShowHelp()

	local h = self:CreateFrame( "Help", 300, 400 );
	h:DockPadding( 10, 34, 10, 10 );
	h:SetBackgroundBlur( true );

	local t = self:CreateLabel( h, FILL, "COI 18", I18( "help_text" ), 7 );
	t:SetWrap( true );

end