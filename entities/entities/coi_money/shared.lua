ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_junk/garbage_bag001a.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );

	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE );

	if( SERVER ) then

		self:SetUseType( SIMPLE_USE );
		self:SetCustomCollisionCheck( true );

		local phys = self:GetPhysicsObject();
		if( phys and phys:IsValid() ) then

			if( !self:GetDropped() ) then
				phys:EnableMotion( false );
			elseif( self.Owner and self.Owner:IsValid() ) then
				if( self:GetThrown() ) then
					local aim = self.Owner:GetAimVector();
					phys:SetMass( 70 );
					phys:SetVelocity( self.Owner:GetVelocity() + aim * 300 );
					phys:AddAngleVelocity( Vector( math.Rand( -100, 100 ), math.Rand( -100, 100 ), math.Rand( -100, 100 ) ) );
				end

				self:SetDieTime( CurTime() + 15 );
			end

		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Dropped" );
	self:NetworkVar( "Bool", 1, "Thrown" );
	self:NetworkVar( "Float", 0, "DieTime" );

	if( SERVER ) then
		self:SetDropped( false );
		self:SetThrown( false );
		self:SetDieTime( 0 );
	end

end