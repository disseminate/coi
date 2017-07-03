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
SKIN.COLOR_GLASS = Color( 0, 0, 0, 150 );
SKIN.COLOR_HEALTH = Color( 255, 30, 20 );

SKIN.COLOR_CLOSEBUTTON = Color( 220, 0, 0 );

SKIN.ICON_CLOSE = Material( "coi/icons/close" );

function SKIN:PaintFrame( panel, w, h )

	surface.SetDrawColor( self.COLOR_GLASS );
	surface.DrawRect( 0, 0, w, h );
	surface.DrawRect( 0, 0, w, 24 );

end

derma.DefineSkin( "COI", "COI Skin", SKIN );

function GM:ForceDermaSkin()

	return "COI";

end

function GM:GetSkin()

	return derma.GetNamedSkin( "COI" );

end

derma.RefreshSkins();