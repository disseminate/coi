AddCSLuaFile();

SWEP.Base = "coi_base";
SWEP.PrintName = "Tripwire";
SWEP.HoldType = "slam";

SWEP.ViewModel = "models/weapons/c_slam.mdl";
SWEP.WorldModel = "models/weapons/w_slam.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "slam";
SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;

function SWEP:PrimaryAttack()

	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 32;
	trace.filter = self.Owner;
	local tr = util.TraceLine( trace );

	if( tr.Hit ) then

		--self:SetNextPrimaryFire( math.huge );
		self:SetNextPrimaryFire( CurTime() + 1 );
		self:SetNextSecondaryFire( math.huge );

		self:SendWeaponAnim( ACT_SLAM_STICKWALL_ATTACH );
		self.Owner:SetAnimation( PLAYER_ATTACK1 );

		self.StickPos = tr.HitPos;
		self.StickNormal = tr.HitNormal;
		self.StickEnt = tr.Entity;
		self.RemoveTime = CurTime() + self:SequenceDuration();

	end

end

function SWEP:Deploy()

	self:SendWeaponAnim( ACT_SLAM_STICKWALL_IDLE );
	return true;

end

function SWEP:PlaceMine( pos, norm, e )

	local ang = norm:Angle();
	ang:RotateAroundAxis( ang:Right(), -90 );
	pos = pos + norm * 2;

	local ent = ents.Create( "coi_tripmine" );
	ent:SetPos( pos );
	ent:SetAngles( ang );
	ent:SetPlayer( self.Owner );
	if( e and e:IsValid() ) then
		ent:SetParent( e );
	end
	ent:Spawn();
	ent:Activate();

end

function SWEP:Think()

	if( self.RemoveTime and CurTime() >= self.RemoveTime and SERVER ) then
		
		self:PlaceMine( self.StickPos, self.StickNormal, self.StickEnt );

		self.Owner:StripWeapon( self:GetClass() );
		self.RemoveTime = nil;
		return;

	end

end