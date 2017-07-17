AddCSLuaFile();

SWEP.Base = "weapon_coi_base";
SWEP.PrintName = "Grenade";
SWEP.HoldType = "grenade";

SWEP.ViewModel = "models/weapons/c_grenade.mdl";
SWEP.WorldModel = "models/weapons/w_grenade.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "grenade";
SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( math.huge );
	self:SetNextSecondaryFire( math.huge );

	self:SendWeaponAnim( ACT_VM_PULLBACK_HIGH );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self.RemoveTime = CurTime() + self:SequenceDuration();

end

function SWEP:GrenadeCheckThrow( src )

	local trace = { };
	trace.start = self.Owner:EyePos();
	trace.endpos = src;
	trace.filter = self.Owner;
	trace.mins = Vector( -6, -6, -6 );
	trace.maxs = Vector( 6, 6, 6 );
	local tr = util.TraceHull( trace );

	if( tr.Hit ) then
		return tr.HitPos;
	end
	return src;

end

function SWEP:Throw()

	local fwd = self.Owner:GetForward();
	fwd.z = fwd.z + 0.1;

	local p = self.Owner:EyePos() + fwd * 18 + self.Owner:GetRight() * 8;
	local gpos = self:GrenadeCheckThrow( p );

	local ent = ents.Create( "coi_grenade" );
	ent:SetPos( gpos );
	ent:SetAngles( Angle() );
	ent:SetPlayer( self.Owner );
	ent:Spawn();
	ent:Activate();

end

function SWEP:Think()

	if( self.RemoveTime and CurTime() >= self.RemoveTime and SERVER ) then
		
		self:Throw();

		self.Owner:StripWeapon( self:GetClass() );
		self.RemoveTime = nil;
		return;

	end

end