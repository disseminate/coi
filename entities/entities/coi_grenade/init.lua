AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Think()

	if( self.StartExpl and CurTime() >= self.StartExpl ) then

		self:Explode();

		self:NextThink( CurTime() );
		return true;

	end

end

function ENT:Explode()

	local ed = EffectData();
	ed:SetOrigin( self:GetPos() );
	util.Effect( "Explosion", ed );

	local ply = self:GetPlayer();
	if( !ply or !ply:IsValid() ) then
		ply = self;
	end

	util.BlastDamage( self, ply, self:GetPos(), 256, 300 );

	self:Remove();

end

function ENT:OnTakeDamage( dmg )

	if( dmg:IsBulletDamage() ) then
		self:Explode();
	end

end