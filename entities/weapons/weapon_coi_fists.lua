AddCSLuaFile();

SWEP.Base = "weapon_coi_base";
SWEP.PrintName = "Fists";
SWEP.HoldType = "fist";

SWEP.ViewModel = "models/weapons/c_arms.mdl";
SWEP.WorldModel = "";
SWEP.ViewModelFOV = 54;
SWEP.UseHands = true;

SWEP.Primary.Ammo = "";
SWEP.Primary.Firearm = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Sound = Sound( "WeaponFrag.Throw" );
SWEP.Primary.HitSound = Sound( "Flesh.ImpactHard" );
SWEP.Primary.HitDistance = 80;

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" );
	self:NetworkVar( "Float", 1, "NextIdle" );

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel();
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() );

end

function SWEP:PrimaryAttack( right )

	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	local anim = "fists_left";
	if( math.random( 1, 2 ) == 1 or self.Owner.HasMoney ) then anim = "fists_right"; end

	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) );

	if( SERVER ) then
		self.Owner:EmitSound( self.Primary.Sound );
	end

	self:UpdateNextIdle();
	self:SetNextMeleeAttack( CurTime() + 0.1 );

	self:SetNextPrimaryFire( CurTime() + 0.7 );
	self:SetNextSecondaryFire( CurTime() + 0.7 );

end

function SWEP:DealDamage()

	local anim = self:GetSequenceName( self.Owner:GetViewModel():GetSequence() );

	self.Owner:LagCompensation( true );

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Primary.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} );

	if( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Primary.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} );
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit and SERVER ) then
		self.Owner:EmitSound( self.Primary.HitSound );
	end

	local hit = false;

	if ( SERVER and IsValid( tr.Entity ) and ( tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo();

		local attacker = self.Owner;
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker );

		dmginfo:SetInflictor( self );
		dmginfo:SetDamage( math.random( 8, 12 ) );

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
			dmginfo:SetDamage( math.random( 12, 24 ) )
		end

		tr.Entity:TakeDamageInfo( dmginfo );
		hit = true;

	end

	if ( SERVER and IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject();
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos );
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:Deploy()

	local speed = GetConVarNumber( "sv_defaultdeployspeed" );

	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) );
	vm:SetPlaybackRate( speed );

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed );
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed );
	self:UpdateNextIdle();
	
	return true;

end

function SWEP:Think()

	local vm = self.Owner:GetViewModel();
	local curtime = CurTime();
	local idletime = self:GetNextIdle();

	if( idletime > 0 and CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) );
		self:UpdateNextIdle();

	end

	local meleetime = self:GetNextMeleeAttack();

	if( meleetime > 0 and CurTime() > meleetime ) then

		self:DealDamage();
		self:SetNextMeleeAttack( 0 );

	end

end
