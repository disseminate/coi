local HUDElements = {
	"CHudAmmo",
	"CHudBattery",
	"CHudHealth",
	"CHudWeaponSelection"
};

function GM:HUDShouldDraw( name )

	if( table.HasValue( HUDElements, name ) ) then return false; end

	return self.BaseClass:HUDShouldDraw( name );

end