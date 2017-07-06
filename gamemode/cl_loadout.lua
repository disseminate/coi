function GM:CreateLoadoutPanel()

	if( self.Loadout and self.Loadout:IsValid() ) then
		self.Loadout:Remove();
	end

	self.Loadout = self:CreatePanel( nil, NODOCK, ScrW(), ScrH() );
	self.Loadout:SetPaintBackground( true );
	self.Loadout:SetBackgroundBlur( true );
	self.Loadout:DockPadding( 40, 40, 40, 40 );
	self.Loadout:MakePopup();
	self.Loadout:FadeIn();
	self.Loadout:SetKeyboardInputEnabled( false );

	local p1 = self:CreatePanel( self.Loadout, TOP, 0, 64 );
	p1:DockMargin( 0, 0, 0, 20 );
		local l = self:CreateLabel( p1, LEFT, "COI Title 64", "Select Your Loadout", 7 );
		local p2 = self:CreatePanel( p1, RIGHT, 200, 0 );
		p2:DockPadding( 0, 17, 0, 17 );
			local l = self:CreateLabel( p2, TOP, "COI 16", "Conflict of Interest β", 9 );
			l:SetTextColor( Alpha( self:GetSkin().COLOR_WHITE, 0.7 ) );
			local l = self:CreateLabel( p2, TOP, "COI 14", "Everything subject to change.", 9 );
			l:SetTextColor( Alpha( self:GetSkin().COLOR_WHITE, 0.6 ) );

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

			if( !self.TeamCache ) then
				self.TeamCache = LocalPlayer():Team();
			end

			for _, v in pairs( self.PlayerCache ) do

				if( !v or !v:IsValid() or v:Team() != LocalPlayer():Team() ) then

					self.Invalidated = true;

				end

			end

			for _, v in pairs( player.GetAll() ) do

				if( v:Team() == LocalPlayer():Team() and !table.HasValue( self.PlayerCache, v ) ) then

					self.Invalidated = true;

				end

			end

			if( self.TeamCache != LocalPlayer():Team() ) then
				self.Invalidated = true;
			end

			if( self.Invalidated ) then
				
				self.Invalidated = false;
				self:GetCanvas():Clear();
				self.PlayerCache = { };
				self.TeamCache = LocalPlayer():Team();

				for _, v in pairs( team.GetPlayers( LocalPlayer():Team() ) ) do
					table.insert( self.PlayerCache, v );

					local p3 = GAMEMODE:CreatePanel( self:GetCanvas(), TOP, 0, 80 );
					p3:SetPaintBackground( true );
					p3:DockMargin( 0, 0, 0, 10 );
					p3:DockPadding( 10, 10, 10, 10 );

						local av = GAMEMODE:CreateAvatarImage( p3, LEFT, 60, 60, v );
						av:DockMargin( 0, 0, 10, 0 );

						local p4 = GAMEMODE:CreatePanel( p3, FILL );
							local n = GAMEMODE:CreateLabel( p4, TOP, "COI Title 24", v:Nick(), 7 );
				end

			end

		end
		p2.Invalidated = true;
		
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "Other Teams", 7 );
		l:DockMargin( 0, 0, 0, 20 );
		local p2 = self:CreateScrollPanel( p1, FILL );
		p2:DockMargin( 0, 0, 0, 20 );
		function p2:Think() -- has to be handled by the parent: Think() isn't called when invisible

			if( self:GetCanvas() and self:GetCanvas():IsValid() ) then
				
				for _, v in pairs( self:GetCanvas():GetChildren() ) do
				
					if( v.Team ) then

						if( v.Team == LocalPlayer():Team() ) then
							v:SetVisible( false );
						else
							v:SetVisible( true );
						end

					end

				end

			end

		end

			for k, v in pairs( team.GetAllTeams() ) do

				if( k >= 1 and k <= 128 ) then
					
					local p3 = GAMEMODE:CreatePanel( p2, TOP, 0, 100 );
					p3:SetPaintBackground( true );
					p3:DockMargin( 0, 0, 0, 10 );
					p3.Team = k;

						local p4 = GAMEMODE:CreatePanel( p3, LEFT, 200, 0 );
						p4:DockPadding( 10, 10, 10, 10 );

							local l = GAMEMODE:CreateLabel( p4, TOP, "COI Title 24", team.GetName( k ), 7 );
							l:SetTextColor( team.GetColor( k ) );
							local l = GAMEMODE:CreateLabel( p4, TOP, "COI 20", "99 members", 7 ):BindInput( function()
								return team.NumPlayers( k ) .. " members";
							end );
							l:DockMargin( 0, 0, 0, 10 );
							local b = GAMEMODE:CreateButton( p4, TOP, 80, 26, "Join", function()
								net.Start( "nJoinTeam" );
									net.WriteUInt( k, 16 );
								net.SendToServer();
							end );
							function b:Think()

								if( !GAMEMODE:CanChangeTeam( LocalPlayer():Team(), k ) ) then

									self:SetDisabled( true );

								else

									self:SetDisabled( false );

								end

							end
							b:SetFont( "COI 20" );

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
										break;

									end

								end

								for _, v in pairs( player.GetAll() ) do

									if( v:Team() == self.Team and !table.HasValue( self.PlayerCache, v ) ) then

										self.Invalidated = true;
										break;

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

		local keys = table.GetKeys( self.Items );
		local item = keys[1];
		local ItemData = {
			Name = self.Items[item].Name,
			Desc = self.Items[item].Desc,
			Price = self.Items[item].Price
		};

			local itemModel = self:CreateModelPanel( p2, TOP, 0, 200, self.Items[item].Model, Vector( 50, 50, 20 ), Vector( 0, 0, 0 ), 20 );
			local a, b = itemModel.Entity:GetModelBounds();
			itemModel:SetLookAt( ( a + b ) / 2 );
			itemModel:DockMargin( 0, 0, 0, 10 );
			
			local p3 = self:CreatePanel( p2, FILL );
				local p4 = self:CreatePanel( p3, TOP, 0, 24 );
					local lT = self:CreateLabel( p4, FILL, "COI Title 24", "Shotgun", 4 ):BindInput( function() return ItemData.Name end );
					local lP = self:CreateLabel( p4, RIGHT, "COI 20", "$1,200", 6 ):BindInput( function() return "$" .. string.Comma( ItemData.Price ) end );
					lP:SetTextColor( self:GetSkin().COLOR_MONEY );
				local d = self:CreateLabel( p3, FILL, "COI 16", "An effective killing device.", 7 ):BindInput( function() return ItemData.Desc end );
			
			local p3 = self:CreatePanel( p2, BOTTOM, 0, 40 );

				local function updateItem( dir )

					local idx = -1;
					for k, v in pairs( keys ) do
						if( v == item ) then
							idx = k;
							break;
						end
					end

					if( idx > -1 ) then

						idx = idx + dir;

						if( idx < 1 ) then
							idx = #keys;
						end
						if( idx > #keys ) then
							idx = 1;
						end

						item = keys[idx];
						
						ItemData.Name = self.Items[item].Name;
						ItemData.Desc = self.Items[item].Desc;
						ItemData.Price = self.Items[item].Price;

						itemModel:SetModel( self.Items[item].Model );
						local a, b = itemModel.Entity:GetModelBounds();
						itemModel:SetLookAt( ( a + b ) / 2 );

					end

				end

				local left = self:CreateIconButton( p3, LEFT, 40, 40, self:GetSkin().ICON_LEFT, function()
					updateItem( -1 );
				end );
				left:DockMargin( 0, 0, 10, 0 );
				local right = self:CreateIconButton( p3, RIGHT, 40, 40, self:GetSkin().ICON_RIGHT, function()
					updateItem( 1 );
				end );
				right:DockMargin( 10, 0, 0, 0 );
				local buy = self:CreateButton( p3, FILL, 0, 0, "Buy", function()
				
					net.Start( "nBuyItem" );
						net.WriteString( item );
					net.SendToServer();

					surface.PlaySound( Sound( "coi/kaching2.wav" ) );
				
				end );
				function buy:Think()

					LocalPlayer():CheckInventory();

					local dis = false;
					if( table.HasValue( LocalPlayer().Inventory, item ) ) then
						dis = true;
					end

					if( ( LocalPlayer().Money or 0 ) < ItemData.Price ) then
						dis = true;
					end

					if( dis ) then
						self:SetDisabled( true );
					else
						self:SetDisabled( false );
					end

				end
				buy:SetTextColor( self:GetSkin().COLOR_MONEY );

	local p1 = self:CreatePanel( self.Loadout, FILL );
		local l = self:CreateLabel( p1, TOP, "COI Title 30", "You", 7 );
		l:DockMargin( 0, 0, 0, 20 );

		local p2 = self:CreatePanel( p1, FILL );
			local pw = 840 * ( ScrW() / 1920 ); -- dirty...
			local ph = 300 * ( ScrH() / 1080 );

			local invPanel = self:CreateScrollPanel( p2, TOP, pw, ph );
			invPanel:SetPaintBackground( true );
			invPanel:DockMargin( 0, 0, 0, 20 );
			invPanel.IconSize = pw / 16;
			invPanel:SetTall( invPanel.IconSize * 6 );

			-- should now have a properly scaled 16x6 grid!

			function invPanel:Paint( w, h )

				surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS );
				surface.DrawRect( 0, 0, w, h );
				surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS_LIGHT );

				for i = 1, 15 do
					surface.DrawLine( i * self.IconSize, 0, i * self.IconSize, h );
				end
				for j = 1, 5 do
					surface.DrawLine( 0, j * self.IconSize, w, j * self.IconSize );
				end
				
			end

			local primary, secondary;

			invPanel:Receiver( "item", function( self, tab, dropped, idx, x, y )

				local pan = tab[1];

				if( dropped and pan:GetParent() != self:GetCanvas() ) then

					pan:GetParent().SelectedItem = nil;

					if( pan.Primary ) then

						net.Start( "nClearPrimaryLoadout" );
						net.SendToServer();

					elseif( pan.Secondary ) then

						net.Start( "nClearSecondaryLoadout" );
						net.SendToServer();

					end

					pan:Remove();

					surface.PlaySound( Sound( "coi/equip.wav" ) );

				end

			end );

			self.Loadout.Inventory = invPanel;
			self:ResetLoadoutInventory();

			local p3 = self:CreatePanel( p2, TOP, 0, 200 );
				primary = self:CreatePanel( p3, FILL );
				primary:SetPaintBackground( true );
				primary:DockMargin( 0, 0, 20, 0 );
				self:CreateLabel( primary, FILL, "COI 20", "Primary", 7 ):DockMargin( 10, 10, 0, 0 );
				primary:Receiver( "item", function( self, tab, dropped, idx, x, y )

					local pan = tab[1];
					local v = pan.Item;
					local item = GAMEMODE.Items[v];

					if( dropped and !self.SelectedItem and !item.Secondary ) then
					
						self.SelectedItem = v;

						net.Start( "nSetPrimaryLoadout" );
							net.WriteString( v );
						net.SendToServer();

						local mdl = GAMEMODE:CreateModelPanel( self, FILL, 0, 0, item.Model, Vector( 50, 50, 20 ), nil, 20 );
						GAMEMODE:CreateLabel( mdl, FILL, "COI 18", item.Name, 3 ):DockMargin( 0, 0, 4, 4 );
						mdl.Primary = true;
						mdl:Droppable( "item" );
						function mdl.DoClick( mdl )

							mdl:Remove();
							self.SelectedItem = nil;

							surface.PlaySound( Sound( "coi/equip.wav" ) );

							net.Start( "nClearPrimaryLoadout" );
							net.SendToServer();

						end
						self.Model = mdl;

						surface.PlaySound( Sound( "coi/equip.wav" ) );

					end

				end );

				secondary = self:CreatePanel( p3, RIGHT, ScrW() * 0.17, 0 );
				secondary:SetPaintBackground( true );
				self:CreateLabel( secondary, FILL, "COI 20", "Secondary", 7 ):DockMargin( 10, 10, 0, 0 );
				secondary:Receiver( "item", function( self, tab, dropped, idx, x, y )

					local pan = tab[1];
					local v = pan.Item;
					local item = GAMEMODE.Items[v];

					if( dropped and !self.SelectedItem and item.Secondary ) then
					
						self.SelectedItem = v;

						net.Start( "nSetSecondaryLoadout" );
							net.WriteString( v );
						net.SendToServer();

						local mdl = GAMEMODE:CreateModelPanel( self, FILL, 0, 0, item.Model, Vector( 50, 50, 20 ), nil, 20 );
						GAMEMODE:CreateLabel( mdl, FILL, "COI 18", item.Name, 3 ):DockMargin( 0, 0, 4, 4 );
						mdl.Secondary = true;
						mdl:Droppable( "item" );
						function mdl.DoClick( mdl )

							mdl:Remove();
							self.SelectedItem = nil;

							surface.PlaySound( Sound( "coi/equip.wav" ) );

							net.Start( "nClearSecondaryLoadout" );
							net.SendToServer();

						end
						self.Model = mdl;

						surface.PlaySound( Sound( "coi/equip.wav" ) );

					end

				end );

			p3:DockMargin( 0, 0, 0, 20 );
			
			local l = self:CreateLabel( p2, TOP, "COI 24", "You have", 9 );
			local l2 = self:CreateLabel( p2, TOP, "COI Title 48", "$" .. string.Comma( 0 ), 9 ):BindInput( function()
				return "$" .. string.Comma( LocalPlayer().Money or 0 );
			end );
			l2:SetTextColor( self:GetSkin().COLOR_MONEY );


end

function GM:ResetLoadoutInventory()

	if( !self.Loadout or !self.Loadout:IsValid() or !self.Loadout.Inventory or !self.Loadout.Inventory:IsValid() ) then return end
	local i = self.Loadout.Inventory;

	i:Clear();

	LocalPlayer():CheckInventory();

	local cx = 0;
	local cy = 0;
	local maxh = 0;

	for _, v in pairs( LocalPlayer().Inventory ) do

		local item = self.Items[v];

		if( item ) then

			local iw = item.W * i.IconSize;
			local ih = item.H * i.IconSize;
			mdl = self:CreateModelPanel( i, NODOCK, iw, ih, item.Model, Vector( 50, 50, 20 ), nil, 20 );

			if( cx + iw >= i:GetWide() ) then

				cx = 0;
				cy = cy + maxh;
				maxh = 0;

			end

			mdl:SetPos( cx, cy );
			
			self:CreateLabel( mdl, FILL, "COI 18", item.Name, 3 ):DockMargin( 0, 0, 4, 4 );

			if( ih > maxh ) then
				maxh = ih;
			end

			cx = cx + iw;

			mdl.Item = v;
			mdl:Droppable( "item" );

		end

	end

end