local meta = FindMetaTable( "Panel" );

function GM:CreateFrame( title, w, h )

	local f = vgui.Create( "DFrame" );
	f:SetTitle( title );
	f:SetSize( w, h );
	f:Center();
	f:FadeIn();
	f:DockPadding( 0, 24, 0, 0 );
	f:MakePopup();
	
	function f:ShowCloseButton() end
	function f:PerformLayout()
		if( self.lblTitle and self.lblTitle:IsValid() ) then
			self.lblTitle:SetPos( 8, 2 );
			self.lblTitle:SetSize( self:GetWide() - 25, 20 );
			self.lblTitle:SetTextColor( Color( 255, 255, 255 ) );
		end
	end

	f.btnClose:Remove();
	f.btnMaxim:Remove();
	f.btnMinim:Remove();

	f.lblTitle:SetFont( "COI 20" );

	local closeBut = self:CreateIconButton( f, NODOCK, 24, 24, self:GetSkin().ICON_CLOSE, function()
		f:FadeOut();

		if( f.OnClose ) then
			f.OnClose();
		end
	end );
	closeBut:SetPos( w - 24, 0 );
	closeBut:SetIconPadding( 4 );
	closeBut:SetIconColor( self:GetSkin().COLOR_CLOSEBUTTON );

	return f;

end

function GM:CreateIconButton( p, dock, w, h, icon, click )

	local n = vgui.Create( "DButton", p );
	n:Dock( dock );
	n:SetSize( w, h );
	n:SetText( "" );
	n.Icon = icon;
	n.IconPadding = 0;

	function n:SetIcon( icon )

		self.Icon = icon;

	end

	function n:Paint( w, h )

		local dim = 24;
		local x = ( w - dim ) / 2;
		local y = ( h - dim ) / 2;

		surface.SetMaterial( self.Icon );
		surface.SetDrawColor( self.IconColor or self:GetSkin().COLOR_WHITE );
		surface.DrawTexturedRect( x + self.IconPadding, y + self.IconPadding, dim - self.IconPadding * 2, dim - self.IconPadding * 2 );

	end

	function n:SetIconColor( col )

		self.IconColor = col;

	end

	function n:SetIconPadding( pad )

		self.IconPadding = pad;

	end

	n.DoClick = click;

	return n;

end

function meta:FadeIn()

	self:SetAlpha( 0 );
	self:AlphaTo( 255, 0.1 );

	self:SetMouseInputEnabled( true );

end

function meta:FadeOut( noclose )

	self:AlphaTo( 0, 0.1, 0, function()
		
		if( !noclose ) then
			
			self:Remove();
			
		end
		
	end );

	self:SetMouseInputEnabled( false );

end