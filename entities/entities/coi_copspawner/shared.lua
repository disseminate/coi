ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/Kleiner.mdl" );

	self:PhysicsInit( SOLID_NONE );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_NONE );

end
