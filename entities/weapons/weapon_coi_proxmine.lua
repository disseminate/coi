AddCSLuaFile();

SWEP.Base = "weapon_coi_tripmine";
SWEP.PrintName = "Proximity Mine";
SWEP.HoldType = "slam";

function SWEP:PlaceMine( pos, norm, e )

	local ang = norm:Angle();
	ang:RotateAroundAxis( ang:Right(), -90 );
	pos = pos + norm * 2;

	local ent = ents.Create( "coi_proxmine" );
	ent:SetPos( pos );
	ent:SetAngles( ang );
	ent:SetPlayer( self.Owner );

	if( e and e:IsValid() ) then
		ent:SetParent( e );
	end

	ent:Spawn();
	ent:Activate();

end