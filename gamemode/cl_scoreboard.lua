function GM:ScoreboardShow()

	if( self.Scoreboard and self.Scoreboard:IsValid() ) then

		self.Scoreboard:FadeIn();

	else

		local sw = math.min( ScrW() - 80, 500 );
		local sw3 = math.floor( sw / 3 );

		self.Scoreboard = self:CreatePanel( nil, NODOCK, sw, ScrH() * 0.7 );
		self.Scoreboard:SetPaintBackground( true );
		self.Scoreboard:DockPadding( 20, 20, 20, 20 );
		self.Scoreboard:MakePopup();
		self.Scoreboard:FadeIn();
		self.Scoreboard:Center();
		self.Scoreboard:SetKeyboardInputEnabled( false );

		self:CreateLabel( self.Scoreboard, TOP, "COI Title 30", "Conflict of Interest", 8 );
		self:CreateLabel( self.Scoreboard, TOP, "COI 20", GetHostName(), 8 ):DockMargin( 0, 0, 0, 20 );

		self.Scoreboard.Players = self:CreateScrollPanel( self.Scoreboard, FILL );

			for k, v in pairs( self.Teams ) do

				local title = self:CreateLabel( self.Scoreboard.Players, TOP, "COI Title 30", team.GetName( k ), 7 );
				title:SetTextColor( team.GetColor( k ) );
				title:DockMargin( 0, 0, 0, 10 );

				local p3 = self:CreatePanel( self.Scoreboard.Players, TOP, 0, 0 );
				p3:DockMargin( 0, 0, 0, 20 );
				p3.Team = k;

				function p3:Think()

					if( !self.PlayerCache ) then
						self.PlayerCache = { };
					end

					for _, v in pairs( self.PlayerCache ) do

						if( !v or !v:IsValid() or v:Team() != self.Team ) then

							self.Invalidated = true;
							break;

						end

					end

					for _, v in pairs( team.GetPlayers( self.Team ) ) do

						if( !table.HasValue( self.PlayerCache, v ) ) then

							self.Invalidated = true;
							break;

						end

					end

					if( self.Invalidated ) then

						self.Invalidated = false;
						self:Clear();
						self.PlayerCache = { };

						local y = 0;

						for _, v in pairs( team.GetPlayers( self.Team ) ) do

							table.insert( self.PlayerCache, v );

							local row = GAMEMODE:CreatePanel( self, TOP, 0, 48 );
							row:DockPadding( 4, 4, 4, 4 );
							row:SetPaintBackground( true );
							row:DockMargin( 0, 0, 0, 4 );
							y = y + 48 + 4; -- row + margin

								local av = GAMEMODE:CreateAvatarImage( row, LEFT, 40, 40, v );
								av:DockMargin( 0, 0, 10, 0 );

								local p4 = GAMEMODE:CreatePanel( row, FILL );
									local n = GAMEMODE:CreateLabel( p4, FILL, "COI 20", v:Nick(), 4 ):BindInput( function()
										if( v and v:IsValid() ) then return v:Nick() end
										return "";
									end );
									local ping = GAMEMODE:CreateLabel( p4, RIGHT, "COI 16", "999", 6 ):BindInput( function()
										if( v and v:IsValid() ) then return "" .. v:Ping() end
										return "";
									end );
									ping:DockMargin( 10, 0, 10, 0 );
									local m = GAMEMODE:CreateIconButton( p4, RIGHT, 40, 40, v:IsMuted() and self:GetSkin().ICON_AUDIO_OFF or self:GetSkin().ICON_AUDIO_ON, function( b )

										if( v:IsMuted() ) then
											v:SetMuted( false );
											b:SetIcon( self:GetSkin().ICON_AUDIO_ON );
										else
											v:SetMuted( true );
											b:SetIcon( self:GetSkin().ICON_AUDIO_OFF );
										end

									end );

						end

						self:SetTall( y );

					end

				end
				p3.Invalidated = true;

			end

	end

end

function GM:ScoreboardHide()

	self.Scoreboard:FadeOut( true );

end