AddCSLuaFile();

SWEP.Base = "weapon_coi_base";
SWEP.PrintName = "Taser";
SWEP.HoldType = "pistol";

SWEP.ViewModel = "models/weapons/c_pistol.mdl";
SWEP.WorldModel = "models/weapons/w_pistol.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "pistol";
SWEP.Primary.Firearm = true;
SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Sound = Sound( "ambient/energy/zap2.wav" );
SWEP.Primary.Delay = 0.1;
SWEP.Primary.Spread = 0.02;
SWEP.Primary.InfiniteAmmo = true;

SWEP.ReloadSound = Sound( "Weapon_Pistol.Reload" );

function SWEP:Attack()

	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 200;
	trace.filter = self.Owner;
	trace.mins = Vector( -12, -12, -12 );
	trace.maxs = Vector( 12, 12, 12 );

	self.Owner:LagCompensation( true );
	local tr = util.TraceHull( trace );
	self.Owner:LagCompensation( false );

	if( tr.Entity and tr.Entity:IsValid() ) then

		if( tr.Entity.TakeDamageInfo and SERVER ) then

			local dmg = DamageInfo();
			dmg:SetDamage( 100 );
			dmg:SetAttacker( self.Owner );
			dmg:SetInflictor( self );
			dmg:SetDamageType( DMG_SHOCK );
			dmg:SetDamagePosition( tr.HitPos );
			dmg:SetDamageForce( self.Owner:GetAimVector() * 50 );
			tr.Entity:TakeDamageInfo( dmg );
			
		end

	end

end