local sizes = { 12, 14, 16, 18, 20, 24, 30, 48, 64, 128 };

for _, v in pairs( sizes ) do

	surface.CreateFont( "COI " .. v, {
		font = "Open Sans",
		size = v,
		weight = 500
	} );

	surface.CreateFont( "COI Title " .. v, {
		font = "Arvo",
		size = v,
		weight = 500
	} );

end

SKIN = { };

SKIN.COLOR_WHITE = Color( 255, 255, 255 );
SKIN.COLOR_GRAY = Color( 255, 255, 255, 150 );
SKIN.COLOR_GLASS = Color( 0, 0, 0, 180 );
SKIN.COLOR_GLASS_OUTLINE = Color( 0, 0, 0, 150 );
SKIN.COLOR_GLASS_LIGHT = Color( 0, 0, 0, 120 );
SKIN.COLOR_GLASS_DARK = Color( 0, 0, 0, 220 );
SKIN.COLOR_HEALTH = Color( 255, 30, 20 );
SKIN.COLOR_MONEY = Color( 122, 255, 62 );
SKIN.COLOR_WARNING = Color( 255, 100, 20 );

SKIN.COLOR_SUCCESS = SKIN.COLOR_MONEY;
SKIN.COLOR_FAIL = Color( 200, 0, 0 );

SKIN.COLOR_CLOSEBUTTON = Color( 220, 0, 0 );

SKIN.ICON_CLOSE = Material( "coi/icons/close" );
SKIN.ICON_LEFT = Material( "coi/icons/left" );
SKIN.ICON_RIGHT = Material( "coi/icons/right" );
SKIN.ICON_AUDIO_OFF = Material( "coi/icons/audio-off" );
SKIN.ICON_AUDIO_ON = Material( "coi/icons/audio-on" );
SKIN.ICON_ARROW = Material( "coi/icons/arrow" );
SKIN.ICON_TRASH = Material( "coi/icons/trash" );
SKIN.ICON_GEAR = Material( "coi/icons/gear" );

SKIN.MAT_GREEN = Material( "coi/vgui/green" );
SKIN.MAT_REDLASER = Material( "coi/sprites/redlaser" );
SKIN.MAT_GLOW = Material( "coi/sprites/glow01" );

function SKIN:PaintFrame( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS );
	surface.DrawRect( 0, 0, w, h );
	surface.DrawRect( 0, 0, w, 24 );

end

function SKIN:PaintVScrollBar( panel, w, h )

	

end

function SKIN:PaintScrollBarGrip( panel, w, h )

	self:PaintButton( panel, w, h );

end

function SKIN:PaintButtonDown( panel, w, h )

	self:PaintButton( panel, w, h );

end

function SKIN:PaintButtonUp( panel, w, h )

	self:PaintButton( panel, w, h );

end

function SKIN:PaintButton( panel, w, h )

	if( panel:GetDisabled() ) then

		surface.SetAlphaMultiplier( 0.3 );
			surface.SetDrawColor( panel.ButtonColor or self.COLOR_GLASS );
			surface.DrawRect( 0, 0, w, h );
		surface.SetAlphaMultiplier( 1 );
		return;

	end

	if( !panel.HoverPerc ) then
		panel.HoverPerc = 0;
	end

	if( panel:IsHovered() ) then
		panel.HoverPerc = math.Approach( panel.HoverPerc, 1, ( 1 - panel.HoverPerc ) * ( 1 / 45 ) );
	else
		panel.HoverPerc = math.Approach( panel.HoverPerc, 0, ( panel.HoverPerc ) * ( 1 / 45 ) );
	end

	-- there is no surface.GetAlphaMultiplier, so guess what I have to do
	local col = Alpha( panel.ButtonColor or self.COLOR_GLASS, 1 - 0.3 * panel.HoverPerc );
	surface.SetDrawColor( col );
	surface.DrawRect( 0, 0, w, h );
	surface.SetDrawColor( self.COLOR_GLASS_OUTLINE );
	surface.DrawOutlinedRect( 0, 0, w, h );

end

function SKIN:PaintCheckBox( panel, w, h )

	self:PaintButton( panel, w, h );

	if( panel:GetChecked() ) then

		surface.SetDrawColor( self.COLOR_WHITE );
		surface.DrawRect( w / 3, h / 3, w * ( 1 / 3 ), h * ( 1 / 3 ) );

	end

end

derma.DefineSkin( "COI", "COI Skin", SKIN );

function GM:ForceDermaSkin()

	return "COI";

end

function GM:GetSkin()

	return derma.GetNamedSkin( "COI" );

end

derma.RefreshSkins();