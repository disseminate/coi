SWEP.Base = "weapon_base";
SWEP.PrintName = "COI Base";

function SWEP:Attack()

	local bull = { };
	bull.Attacker = self.Owner;
	bull.Damage = 5;
	bull.Dir = self.Owner:GetAimVector();
	bull.Spread = Vector( self.Primary.Spread, self.Primary.Spread, 0 );
	bull.Src = self.Owner:GetShootPos();
	bull.Num = self.Primary.Num or 1;
	bull.Force = self.Primary.Force or 1;
	self:FireBullets( bull );

end

function SWEP:PrimaryAttack()

	if( self.Primary.Firearm ) then

		if( self:Clip1() >= 1 ) then
			
			self:SetClip1( self:Clip1() - 1 );

			if( SERVER ) then
				self.Owner:EmitSound( self.Primary.Sound );
			end

			self:Attack();

			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
			self.Owner:MuzzleFlash();
			self.Owner:SetAnimation( PLAYER_ATTACK1 );

			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay );

			if( self.ShotgunReload ) then
				self.NeedPump = true;
			end

		else

			if( SERVER ) then
				self.Owner:EmitSound( "Weapon_Pistol.Empty" );
			end

			self:SetNextPrimaryFire( CurTime() + 0.2 );

		end

	end

end

function SWEP:SecondaryAttack()



end

function SWEP:Reload()

	if( self.Primary.Firearm and self:Clip1() < self.Primary.ClipSize ) then
		
		if( self.ShotgunReload ) then

			if( self.InReload ) then return end
			if( self.NeedPump ) then return end

			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START );

			self.Owner:SetAnimation( PLAYER_RELOAD );
			self:SetBodygroup( 1, 0 );

			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
			self.InReload = true;

		elseif( !self.FinishReload ) then
		
			self:SendWeaponAnim( ACT_VM_RELOAD );
			self.FinishReload = CurTime() + self:SequenceDuration();

			self:SetNextPrimaryFire( self.FinishReload );
			self:SetNextSecondaryFire( self.FinishReload );
			
			if( self.ReloadSound and SERVER ) then
				self.Owner:EmitSound( self.ReloadSound );
			end

			self.Owner:SetAnimation( PLAYER_RELOAD );

		end

	end

end

function SWEP:FillClip()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	if( self:Clip1() < self.Primary.ClipSize ) then
		
		self:SetClip1( self:Clip1() + 1 );
		
	end
	
end

function SWEP:ReloadProgress()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	if( self:Clip1() >= self.Primary.ClipSize ) then return end
	
	self:FillClip();
	
	if( SERVER ) then
		self.Owner:EmitSound( Sound( "Weapon_Shotgun.Reload" ) );
	end

	self:SendWeaponAnim( ACT_VM_RELOAD );

	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
	
end

function SWEP:FinishShotgunReload()
	
	self:SetBodygroup( 1, 1 );
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	self.InReload = false;
	
	self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
	
end

function SWEP:Pump()
	
	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	self.NeedPump = false;

	if( SERVER ) then
		self.Owner:EmitSound( Sound( "Weapon_Shotgun.Special1" ) );
	end

	self:SendWeaponAnim( ACT_SHOTGUN_PUMP );
	
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() );
	
end

function SWEP:ShotgunThink()

	if( !self.Owner or !self.Owner:IsValid() ) then return end
	
	if( self.InReload ) then
		
		if( self:GetNextPrimaryFire() <= CurTime() ) then
			
			if( self:Clip1() < self.Primary.ClipSize ) then
				
				self:ReloadProgress();
				
			else
				
				self:FinishShotgunReload();
				
			end
			
		end
		
	else
		
		self:SetBodygroup( 1, 1 );
		
	end
	
	if( self.NeedPump and self:GetNextPrimaryFire() <= CurTime() ) then
		
		self:Pump();
		
	end

end

function SWEP:Think()

	if( self.ShotgunReload ) then
		self:ShotgunThink();
	end

	if( self.FinishReload and CurTime() >= self.FinishReload ) then

		self.FinishReload = nil;
		self:SetClip1( self.Primary.ClipSize );

	end

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType or "pistol" )

end

function SWEP:PreDrawViewModel( vm, wep, ply )

	if( self.NoDraw ) then

		vm:SetMaterial( "engine/occlusionproxy" );

	end

end

function SWEP:Holster()

	self.Owner:GetViewModel():SetMaterial( "" );
	return true;

end