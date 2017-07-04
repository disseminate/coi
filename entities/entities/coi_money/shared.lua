ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_junk/garbage_bag001a.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	if( SERVER ) then

		self:SetUseType( SIMPLE_USE );

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			phys:EnableMotion( false );

		end

	end

end