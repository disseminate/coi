function GM:ScoreboardShow()

	if( self.Scoreboard and self.Scoreboard:IsValid() ) then

		self.Scoreboard:FadeIn();

	else

		local sw = math.min( ScrW() - 80, 500 );
		local sw3 = math.floor( sw / 3 );

		self.Scoreboard = self:CreatePanel( nil, NODOCK, sw, ScrH() * 0.7 );
		self.Scoreboard:SetPaintBackground( true );
		self.Scoreboard:DockPadding( 40, 40, 40, 40 );
		self.Scoreboard:MakePopup();
		self.Scoreboard:FadeIn();
		self.Scoreboard:Center();
		self.Scoreboard:SetKeyboardInputEnabled( false );

		self:CreateLabel( self.Scoreboard, TOP, "COI Title 30", "Conflict of Interest", 8 );
		self:CreateLabel( self.Scoreboard, TOP, "COI 20", GetHostName(), 8 ):DockMargin( 0, 0, 0, 20 );

		local p1 = self:CreateScrollPanel( self.Scoreboard, FILL );

			for k, v in pairs( self.Trucks ) do

				local p2 = self:CreatePanel( p1, TOP, 0, 0 );
				p2.Team = k;
				p2:DockMargin( 0, 0, 0, 30 );
					local title = self:CreateLabel( p2, TOP, "COI Title 30", team.GetName( k ), 7 );
					title:SetTextColor( team.GetColor( k ) );
					title:DockMargin( 0, 0, 0, 20 );

				function p2:Think()

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
						local y = 30 + 20; -- title + title margin

						for _, v in pairs( team.GetPlayers( k ) ) do

							local row = GAMEMODE:CreatePanel( p2, TOP, 0, 64 );
							row:DockPadding( 8, 8, 8, 8 );
							row:SetPaintBackground( true );
							row:DockMargin( 0, 0, 0, 4 );

							local av = vgui.Create( "AvatarImage", row );
							av:Dock( LEFT );
							av:SetSize( 48, 48 );
							av:SetPlayer( v, 64 );
							av:DockMargin( 0, 0, 10, 0 );

							local p4 = GAMEMODE:CreatePanel( row, FILL );
								local n = GAMEMODE:CreateLabel( p4, TOP, "COI Title 24", v:Nick(), 7 );

							y = y + 64 + 4; -- row + margin

						end

						self:SetTall( y );

					end

				end
				p2.Invalidated = true;

			end

	end

end

function GM:ScoreboardHide()

	self.Scoreboard:FadeOut( true );

end