AddCSLuaFile();

SWEP.Base = "coi_base";
SWEP.PrintName = "Medkit";
SWEP.HoldType = "slam";

SWEP.ViewModel = "models/weapons/c_medkit.mdl";
SWEP.WorldModel = "models/weapons/w_medkit.mdl";
SWEP.ViewModelFOV = 54;
SWEP.UseHands = true;

SWEP.Primary.Ammo = "";
SWEP.Primary.Firearm = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = true;
SWEP.Primary.Delay = 3;
SWEP.Primary.Sound = Sound( "Weapon_Crowbar.Single" );

function SWEP:PrimaryAttack()

	if( SERVER and self.Primary.Sound ) then
		self.Owner:EmitSound( self.Primary.Sound );
	end

	self:Attack();
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );

	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay );

end

function SWEP:Attack()

	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
	trace.filter = self.Owner;
	trace.mins = Vector( -12, -12, -12 );
	trace.maxs = Vector( 12, 12, 12 );
	local tr = util.TraceHull( trace );

	if( SERVER ) then

		self.Owner:EmitSound( Sound( "HealthKit.Touch" ) );

	end

	if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() and tr.Entity:Alive() ) then

		tr.Entity:SetHealth( math.Clamp( tr.Entity:Health() + 20, 0, tr.Entity:GetMaxHealth() ) );

	else

		self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 20, 0, self.Owner:GetMaxHealth() ) );

	end

end