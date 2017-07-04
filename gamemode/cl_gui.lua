local meta = FindMetaTable( "Panel" );

local matBlurScreen = Material( "pp/blurscreen" );

function surface.BackgroundBlur( x, y, w, h, a )

	if( a == 0 ) then return end
	
	local Fraction = 1;

	DisableClipping( true );

	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 * ( a or 1 ) );

	for i=0.33, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", 5 * i );
		matBlurScreen:Recompute();
		if( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
		surface.DrawTexturedRect( x * -1, y * -1, w, h );
	end

	DisableClipping( false );

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

function GM:CreatePanel( p, dock, w, h )

	local n = vgui.Create( "EditablePanel", p );
	n:Dock( dock );
	if( w and h ) then
		n:SetSize( w, h );
	end

	function n:Paint( w, h )

		if( self.BlurBackground ) then

			surface.BackgroundBlur( 0, 0, w, h, 1 )

		end

		if( self.PaintBackground ) then

			surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS_DARK );
			surface.DrawRect( 0, 0, w, h );

		end

	end

	function n:SetBackgroundBlur( b )

		self.BlurBackground = b;

	end

	function n:SetPaintBackground( b )

		self.PaintBackground = b;

	end

	return n;

end

function GM:CreateScrollPanel( p, dock, w, h )

	local n = vgui.Create( "DScrollPanel", p );
	n:Dock( dock );
	if( w and h ) then
		n:SetSize( w, h );
	end

	function n:Paint( w, h )

		if( self.PaintBackground ) then

			surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS_DARK );
			surface.DrawRect( 0, 0, w, h );

		end

	end

	function n:SetPaintBackground( b )

		self.PaintBackground = b;

	end

	return n;

end

function GM:CreateLabel( p, dock, font, text, align )

	local n = vgui.Create( "DLabel", p );
	n:Dock( dock );
	n:SetFont( font );
	n:SetText( text );
	n:SizeToContents();
	n:SetContentAlignment( align );
	n:SetTextColor( self:GetSkin().COLOR_WHITE );
	
	return n;

end