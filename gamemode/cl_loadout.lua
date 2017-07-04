function GM:CreateLoadoutPanel()

	self.Loadout = self:CreatePanel( nil, NODOCK, ScrW(), ScrH() );
	self.Loadout:SetPaintBackground( true );
	self.Loadout:SetBackgroundBlur( true );
	self.Loadout:DockPadding( 40, 40, 40, 40 );
	self.Loadout:MakePopup();

	local l = self:CreateLabel( self.Loadout, TOP, "COI Title 64", "Select Your Loadout", 7 );
	l:DockMargin( 0, 0, 0, 20 );

	local p1 = self:CreatePanel( self.Loadout, BOTTOM, 0, 68 );

		-- REMOVE ME
		local b = vgui.Create( "DButton", p1 );
		b:SetPos( 0, 68 - 40 );
		b:SetSize( 100, 40 );
		b:SetText( "Close" );
		function b:DoClick()

			GAMEMODE.Loadout:FadeOut();

		end
		-- END REMOVE ME

		local p2 = self:CreatePanel( p1, RIGHT, 200, 0 );

		self:CreateLabel( p2, TOP, "COI 20", "Robbing bank in", 9 );
		self:CreateLabel( p2, FILL, "COI Title 48", "00:43", 9 );

	local p1 = self:CreatePanel( self.Loadout, LEFT, ScrW() * 0.3, 0 );
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "Team Green", 7 );
		l:DockMargin( 0, 0, 0, 20 );

		local p2 = self:CreateScrollPanel( p1, TOP, 0, ScrH() * 0.3 );
		p2:DockMargin( 0, 0, 0, 20 );
			for i = 1, 10 do
				local p3 = self:CreatePanel( p2, TOP, 0, 80 );
				p3:SetPaintBackground( true );
				p3:DockMargin( 0, 0, 0, 10 );
			end
		
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "Other Teams", 7 );
		l:DockMargin( 0, 0, 0, 20 );
		local p2 = self:CreateScrollPanel( p1, FILL );
		p2:DockMargin( 0, 0, 0, 20 );
			for i = 1, 10 do
				local p3 = self:CreatePanel( p2, TOP, 0, 100 );
				p3:SetPaintBackground( true );
				p3:DockMargin( 0, 0, 0, 10 );

					local p4 = self:CreatePanel( p3, LEFT, 200, 0 );
					p4:DockPadding( 10, 10, 10, 10 );

						local l = self:CreateLabel( p4, TOP, "COI Title 24", "Team Purple", 7 );
						local l = self:CreateLabel( p4, TOP, "COI 20", "4 members", 7 );

					local p4 = self:CreatePanel( p3, FILL );
					p4:DockPadding( 10, 10, 10, 10 );

						local p5 = self:CreateScrollPanel( p4, FILL );

							for j = 1, 4 do
								local l = self:CreateLabel( p5, TOP, "COI 18", "Jimbo John", 7 );
								l:DockMargin( 0, 0, 0, 2 );
							end
			end

end