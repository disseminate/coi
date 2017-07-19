ENT.Base = "coi_money";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_junk/garbage_bag001a.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER );

	if( SERVER ) then

		self:SetUseType( SIMPLE_USE );
		self:SetCustomCollisionCheck( true );

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			if( self:GetPlayer() and self:GetPlayer():IsValid() ) then
				local aim = self:GetPlayer():GetAimVector();
				phys:SetMass( 70 );
				phys:SetVelocity( self:GetPlayer():GetVelocity() + aim * 300 );
				phys:AddAngleVelocity( Vector( math.Rand( -100, 100 ), math.Rand( -100, 100 ), math.Rand( -100, 100 ) ) );

				self:SetDieTime( CurTime() + 15 );
			end

		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Player" );
	self:NetworkVar( "Float", 0, "DieTime" );

end