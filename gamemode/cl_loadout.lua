function GM:CreateLoadoutPanel()

	self.Loadout = self:CreatePanel( nil, NODOCK, ScrW(), ScrH() );
	self.Loadout:SetPaintBackground( true );
	self.Loadout:SetBackgroundBlur( true );
	self.Loadout:DockPadding( 40, 40, 40, 40 );
	self.Loadout:MakePopup();
	self.Loadout:FadeIn();
	self.Loadout:SetKeyboardInputEnabled( false );

	local l = self:CreateLabel( self.Loadout, TOP, "COI Title 64", "Select Your Loadout", 7 );
	l:DockMargin( 0, 0, 0, 20 );

	local p1 = self:CreatePanel( self.Loadout, BOTTOM, 0, 68 );

		local p2 = self:CreatePanel( p1, RIGHT, 200, 0 );

		self:CreateLabel( p2, TOP, "COI 20", "Robbing bank in", 9 );
	 	self:CreateLabel( p2, FILL, "COI Title 48", "00:43", 9 ):BindInput( function()
		 	if( GAMEMODE:GetState() == STATE_PREGAME ) then
				local timeLeft = GAMEMODE:TimeLeftInState();
				return string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
			end
			return "a moment...";
		end );

	local p1 = self:CreatePanel( self.Loadout, LEFT, ScrW() * 0.3, 0 );
		p1:DockMargin( 0, 0, 20, 0 );
		local p2 = self:CreatePanel( p1, TOP, 0, 30 );
			self:CreateLabel( p2, LEFT, "COI Title 30", "Your Team", 7 ):DockMargin( 0, 0, 10, 0 );
			local l = self:CreateLabel( p2, FILL, "COI Title 24", "Team Green", 4 ):BindInput( function( panel )
				panel:SetTextColor( team.GetColor( LocalPlayer():Team() ) );
				return team.GetName( LocalPlayer():Team() );
			end );
			l:SizeToContents();
		p2:DockMargin( 0, 0, 0, 20 );

		local p2 = self:CreateScrollPanel( p1, TOP, 0, ScrH() * 0.3 );
		p2:DockMargin( 0, 0, 0, 20 );
		function p2:Think()
			
			if( !self.PlayerCache ) then
				self.PlayerCache = { };
			end

			for _, v in pairs( self.PlayerCache ) do

				if( !v or !v:IsValid() or v:Team() != LocalPlayer():Team() ) then

					GAMEMODE.Loadout.MyTeamInvalidated = true;

				end

			end

			for _, v in pairs( player.GetAll() ) do

				if( v:Team() == LocalPlayer():Team() and !table.HasValue( self.PlayerCache, v ) ) then

					GAMEMODE.Loadout.MyTeamInvalidated = true;

				end

			end

			if( !self.TeamCache ) then
				self.TeamCache = LocalPlayer():Team();
			end

			if( self.TeamCache != LocalPlayer():Team() ) then
				GAMEMODE.Loadout.MyTeamInvalidated = true;
			end

			if( GAMEMODE.Loadout.MyTeamInvalidated ) then
				
				GAMEMODE.Loadout.MyTeamInvalidated = false;
				self:Clear();
				self.PlayerCache = { };

				for _, v in pairs( team.GetPlayers( LocalPlayer():Team() ) ) do
					table.insert( self.PlayerCache, v );

					local p3 = GAMEMODE:CreatePanel( self, TOP, 0, 80 );
					p3:SetPaintBackground( true );
					p3:DockMargin( 0, 0, 0, 10 );
					p3:DockPadding( 10, 10, 10, 10 );

					local av = vgui.Create( "AvatarImage", p3 );
					av:Dock( LEFT );
					av:SetSize( 60, 60 );
					av:SetPlayer( v, 64 );
					av:DockMargin( 0, 0, 10, 0 );

					local p4 = GAMEMODE:CreatePanel( p3, FILL );
						local n = GAMEMODE:CreateLabel( p4, TOP, "COI Title 24", v:Nick() );
				end

			end

		end
		GAMEMODE.Loadout.MyTeamInvalidated = true;
		
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "Other Teams", 7 );
		l:DockMargin( 0, 0, 0, 20 );
		local p2 = self:CreateScrollPanel( p1, FILL );
		p2:DockMargin( 0, 0, 0, 20 );

			for k, v in pairs( team.GetAllTeams() ) do

				if( k >= 1 and k <= 128 and k != LocalPlayer():Team() ) then
					
					local p3 = GAMEMODE:CreatePanel( p2, TOP, 0, 100 );
					p3:SetPaintBackground( true );
					p3:DockMargin( 0, 0, 0, 10 );

						local p4 = GAMEMODE:CreatePanel( p3, LEFT, 200, 0 );
						p4:DockPadding( 10, 10, 10, 10 );

							local l = GAMEMODE:CreateLabel( p4, TOP, "COI Title 24", team.GetName( k ), 7 );
							l:SetTextColor( team.GetColor( k ) );
							local l = GAMEMODE:CreateLabel( p4, TOP, "COI 20", "99 members", 7 ):BindInput( function()
								return team.NumPlayers( k ) .. " members";
							end );

						local p4 = GAMEMODE:CreatePanel( p3, FILL );
						p4:DockPadding( 10, 10, 10, 10 );

							local p5 = GAMEMODE:CreateScrollPanel( p4, FILL );
							p5.Team = k;
							function p5:Think()

								if( !self.PlayerCache ) then
									self.PlayerCache = { };
								end

								for _, v in pairs( self.PlayerCache ) do

									if( !v or !v:IsValid() or v:Team() != self.Team ) then

										self.Invalidated = true;

									end

								end

								for _, v in pairs( player.GetAll() ) do

									if( v:Team() == self.Team and !table.HasValue( self.PlayerCache, v ) ) then

										self.Invalidated = true;

									end

								end

								if( self.Invalidated ) then
									
									self.Invalidated = false;
									self:GetCanvas():Clear();
									self.PlayerCache = { };
									
									for _, v in pairs( team.GetPlayers( self.Team ) ) do

										table.insert( self.PlayerCache, v );
										local l = GAMEMODE:CreateLabel( self:GetCanvas(), TOP, "COI 18", v:Nick(), 7 );
										l:DockMargin( 0, 0, 0, 2 );

									end

								end

							end
							p5.Invalidated = true;

				end

			end
	
	local p1 = self:CreatePanel( self.Loadout, LEFT, ScrW() * 0.2, 0 );
		p1:DockMargin( 0, 0, 20, 0 );
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "Store", 7 );
		l:DockMargin( 0, 0, 0, 20 );

		local p2 = self:CreatePanel( p1, TOP, 0, 400 );
		p2:SetPaintBackground( true );
		p2:DockPadding( 10, 10, 10, 10 );
			local m = self:CreateModelPanel( p2, TOP, 0, 200, "models/Kleiner.mdl", Vector( 50, 50, 64 ), Vector( 0, 0, 60 ), 20 );
			m:DockMargin( 0, 0, 0, 10 );
			
			local p3 = self:CreatePanel( p2, FILL );
				local p4 = self:CreatePanel( p3, TOP, 0, 24 );
					local lT = self:CreateLabel( p4, FILL, "COI Title 24", "Shotgun", 4 );
					local lP = self:CreateLabel( p4, RIGHT, "COI 20", "$1,200", 6 );
					lP:SetTextColor( self:GetSkin().COLOR_MONEY );
				local d = self:CreateLabel( p3, FILL, "COI 16", "An effective killing device.", 7 );
			
			local p3 = self:CreatePanel( p2, BOTTOM, 0, 40 );
				local left = self:CreateIconButton( p3, LEFT, 40, 40, self:GetSkin().ICON_LEFT, function() end );
				left:DockMargin( 0, 0, 10, 0 );
				local right = self:CreateIconButton( p3, RIGHT, 40, 40, self:GetSkin().ICON_RIGHT, function() end );
				right:DockMargin( 10, 0, 0, 0 );
				local buy = self:CreateButton( p3, FILL, 0, 0, "Buy", function() end );
				buy:SetTextColor( self:GetSkin().COLOR_MONEY );

	local p1 = self:CreatePanel( self.Loadout, FILL );
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "You", 7 );
		l:DockMargin( 0, 0, 0, 20 );

		local p2 = self:CreatePanel( p1, FILL );
			local invPanel = self:CreatePanel( p2, TOP, 0, 300 );
			invPanel:SetPaintBackground( true );
			invPanel:DockMargin( 0, 0, 0, 20 );

			local p3 = self:CreatePanel( p2, TOP, 0, 200 );
				local primary = self:CreatePanel( p3, FILL );
				primary:SetPaintBackground( true );
				primary:DockMargin( 0, 0, 20, 0 );
				primary:DockPadding( 10, 10, 10, 10 );
				self:CreateLabel( primary, FILL, "COI 20", "Primary", 7 );

				local secondary = self:CreatePanel( p3, RIGHT, ScrW() * 0.17, 0 );
				secondary:SetPaintBackground( true );
				secondary:DockPadding( 10, 10, 10, 10 );
				self:CreateLabel( secondary, FILL, "COI 20", "Secondary", 7 );

			p3:DockMargin( 0, 0, 0, 20 );
			
			local l = self:CreateLabel( p2, TOP, "COI 24", "You have", 9 );
			local l2 = self:CreateLabel( p2, TOP, "COI Title 48", "$1,243,566", 9 );
			l2:SetTextColor( self:GetSkin().COLOR_MONEY );


end