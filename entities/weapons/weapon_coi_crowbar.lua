AddCSLuaFile();

SWEP.Base = "weapon_coi_base";
SWEP.PrintName = "Crowbar";
SWEP.HoldType = "melee";

SWEP.ViewModel = "models/weapons/c_crowbar.mdl";
SWEP.WorldModel = "models/weapons/w_crowbar.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "";
SWEP.Primary.Firearm = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = true;
SWEP.Primary.Delay = 0.4;
SWEP.Primary.Sound = Sound( "Weapon_Crowbar.Single" );

function SWEP:PrimaryAttack()

	if( SERVER and self.Primary.Sound ) then
		self.Owner:EmitSound( self.Primary.Sound );
	end

	local hit = self:Attack();

	if( hit ) then
		self:SendWeaponAnim( ACT_VM_HITCENTER );
	else
		self:SendWeaponAnim( ACT_VM_MISSCENTER );
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	if( self.Primary.ViewPunch ) then
		self.Owner:ViewPunch( self.Primary.ViewPunch );
	end

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

	if( tr.Hit ) then

		if( tr.Entity and tr.Entity:IsValid() ) then

			self.Owner:EmitSound( Sound( "Weapon_Crowbar.Melee_Hit" ) );

			if( tr.Entity.TakeDamageInfo ) then

				local dmg = DamageInfo();
				dmg:SetDamage( 20 );
				dmg:SetAttacker( self.Owner );
				dmg:SetInflictor( self );
				dmg:SetDamageType( DMG_CLUB );
				dmg:SetDamagePosition( tr.HitPos );
				tr.Entity:TakeDamageInfo( dmg );

			end

		else

			local bull = { };
			bull.Attacker = self.Owner;
			bull.Damage = 0;
			bull.Dir = self.Owner:GetAimVector();
			bull.Spread = Vector();
			bull.Src = self.Owner:GetShootPos();
			bull.Num = 1;
			bull.Force = 0;
			self:FireBullets( bull );

		end

		return true;

	end

end