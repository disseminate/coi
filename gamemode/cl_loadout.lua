function GM:CreateLoadoutPanel()

	self.Loadout = self:CreatePanel( nil, NODOCK, ScrW(), ScrH() );
	self.Loadout:SetPaintBackground( true );
	self.Loadout:SetBackgroundBlur( true );
	self.Loadout:MakePopup();

	local b = vgui.Create( "DButton", self.Loadout );
	b:SetPos( 10, ScrH() - 50 );
	b:SetSize( 100, 40 );
	b:SetText( "Close" );
	function b:DoClick()

		GAMEMODE.Loadout:FadeOut();

	end

end