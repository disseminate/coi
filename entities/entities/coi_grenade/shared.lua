ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/weapons/w_grenade.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER );

	self:UseTriggerBounds( true, 24 );

	if( SERVER ) then

		self.StartExpl = CurTime() + 2;

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			if( self:GetPlayer() and self:GetPlayer():IsValid() ) then

				local fwd = self:GetPlayer():GetForward();
				fwd.z = fwd.z + 0.1;
		
				local aim = self:GetPlayer():GetAimVector();
				phys:SetVelocity( self:GetPlayer():GetVelocity() + fwd * 800 );
				phys:AddAngleVelocity( Vector( 600, math.random( -1200, 1200 ), 0 ) );
				
			end

		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Player" );

end