local meta = FindMetaTable( "Panel" );

local matBlurScreen = Material( "pp/blurscreen" );

function surface.BackgroundBlur( x, y, w, h, a )

	if( a == 0 ) then return end
	
	local Fraction = 1;

	DisableClipping( true );

	surface.SetMaterial( matBlurScreen );
	surface.SetDrawColor( 255, 255, 255, 255 * ( a or 1 ) );

	for i=0, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", 7 * i );
		matBlurScreen:Recompute();
		if( render ) then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect( x * -1, y * -1, w, h );
	end

	DisableClipping( false );

end

function surface.DrawProgressCircle( x, y, perc, radius, bgCol )

	perc = math.Clamp( perc, 0, 1 );
	
	local nOuterVerts = 64;
	local v = { };

	surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_WHITE );

	for outer = 0, nOuterVerts do
		local perc1 = outer / nOuterVerts;
		local perc2 = ( outer + 1 ) / nOuterVerts;
		local r1 = ( perc1 - 0.25 ) * ( 2 * math.pi );
		local r2 = ( perc2 - 0.25 ) * ( 2 * math.pi );
		
		local x1 = math.cos( r1 ) * radius;
		local y1 = math.sin( r1 ) * radius;
		local x2 = math.cos( r2 ) * radius;
		local y2 = math.sin( r2 ) * radius;

		table.insert( v, { x = x + x1, y = y + y1 } );

		if( perc1 <= perc and perc > 0 ) then
			surface.DrawLine( x + x1, y + y1, x + x2, y + y2 );
		end
	end

	bgCol = bgCol or GAMEMODE:GetSkin().COLOR_GLASS_LIGHT;
	
	surface.SetDrawColor( bgCol );
	draw.NoTexture();
	surface.DrawPoly( v );

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

function meta:BindInput( f )

	function self:Think()

		local fm = f( self );

		if( self:GetText() != fm ) then
			self:SetText( fm );
			local d = self:GetDock();
			if( d == NODOCK or d == RIGHT or d == LEFT ) then
				self:SizeToContentsX();
			end
			if( d == NODOCK or d == TOP or d == BOTTOM ) then
				self:SizeToContentsY();
			end
			self:InvalidateLayout();
			self:InvalidateParent();
		end

	end

	return self;

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

function GM:CreateIconPanel( p, dock, w, h, icon )

	local n = vgui.Create( "DPanel", p );
	n:Dock( dock );
	n:SetSize( w, h );
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

			surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS );
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

			surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_GLASS );
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

	if( dock == NODOCK or dock == LEFT or dock == RIGHT ) then
		n:SizeToContentsX();
	end
	if( dock == NODOCK or dock == TOP or dock == BOTTOM ) then
		n:SizeToContentsY();
	end

	if( align ) then
		n:SetContentAlignment( align );
	end
	n:SetTextColor( self:GetSkin().COLOR_WHITE );
	
	return n;

end

function GM:CreateModelPanel( p, dock, w, h, model, campos, lookat, fov )

	local n = vgui.Create( "DModelPanel", p );
	n:Dock( dock );
	if( w and h ) then
		n:SetSize( w, h );
	end
	n:SetModel( model );
	n:SetCamPos( campos );
	local a, b = n.Entity:GetModelBounds();
	n:SetLookAt( ( a + b ) / 2 );
	if( lookat ) then
		n:SetLookAt( lookat );
	end
	n:SetFOV( fov );

	function n:DrawModel()

		local curparent = self
		local rightx = self:GetWide()
		local leftx = 0
		local topy = 0
		local bottomy = self:GetTall()

		if( self.PaintingDragging ) then
			local x, y = self:GetPos();
			rightx = self:GetWide() + x;
			leftx = x;
			topy = y;
			bottomy = self:GetTall() + y;
		end

		local previous = curparent
		while( curparent:GetParent() != nil ) do
			curparent = curparent:GetParent()
			local x, y = previous:GetPos()
			topy = math.Max( y, topy + y )
			leftx = math.Max( x, leftx + x )
			bottomy = math.Min( y + previous:GetTall(), bottomy + y )
			rightx = math.Min( x + previous:GetWide(), rightx + x )
			previous = curparent
		end
		render.SetScissorRect( leftx, topy, rightx, bottomy, true )

		local ret = self:PreDrawModel( self.Entity )
		if ( ret != false ) then
			self.Entity:DrawModel()
			self:PostDrawModel( self.Entity )
		end

		render.SetScissorRect( 0, 0, 0, 0, false )

	end

	return n;

end

function GM:CreateButton( p, dock, w, h, text, click )

	local n = vgui.Create( "DButton", p );
	n:Dock( dock );
	if( w and h ) then
		n:SetSize( w, h );
	end
	n:SetFont( "COI Title 24" );
	n:SetText( text );
	n:SetTextColor( self:GetSkin().COLOR_WHITE );
	n.DoClick = click;

	function n:SetButtonColor( col )

		self.ButtonColor = col;

	end

	return n;

end

function GM:CreateAvatarImage( p, dock, w, h, ply )

	local av = vgui.Create( "AvatarImage", p );
	av:Dock( dock );
	if( w and h ) then
		av:SetSize( w, h );
	end

	local sizes = { 16, 32, 64, 84, 128, 184 };
	local s;
	for _, v in pairs( sizes ) do
		if( v >= w ) then
			s = v;
			break;
		end
	end
	
	av:SetPlayer( ply, s );

	if( !ply:IsBot() ) then
		
		local b = GAMEMODE:CreateButton( av, FILL, 0, 0, "", function()

			if( ply and ply:IsValid() ) then
				gui.OpenURL( "http://steamcommunity.com/profiles/" .. ply:SteamID64() );
			end

		end );
		b.Paint = function() end

	end

	return av;

end

function GM:CreateConfirm( text, cb )

	local n = self:CreateFrame( "Confirm", 300, 180 );
	n:SetBackgroundBlur( true );
	local l = self:CreateLabel( n, FILL, "COI 18", text, 7 );
	l:SetWrap( true );
	l:DockMargin( 10, 10, 10, 10 );

	local p = self:CreatePanel( n, BOTTOM, 0, 60 );
	p:DockPadding( 10, 10, 10, 10 );
	local bCancel = self:CreateButton( p, LEFT, 200, 0, "Cancel", function()
		n:FadeOut();
	end );
	bCancel:DockMargin( 0, 0, 10, 0 );
	local bOK = self:CreateButton( p, FILL, 0, 0, "OK", function()
		cb();
		n:FadeOut();
	end );

end