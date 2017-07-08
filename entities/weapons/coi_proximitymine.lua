AddCSLuaFile();

SWEP.Base = "coi_tripwire";
SWEP.PrintName = "Proximity Mine";
SWEP.HoldType = "slam";

function SWEP:PlaceMine( pos, norm )

	local ang = norm:Angle();
	ang:RotateAroundAxis( ang:Right(), -90 );
	pos = pos + norm * 2;

	local ent = ents.Create( "coi_proxmine" );
	ent:SetPos( pos );
	ent:SetAngles( ang );
	ent:SetPlayer( self.Owner );
	ent:Spawn();
	ent:Activate();

end