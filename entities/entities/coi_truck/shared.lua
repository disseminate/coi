ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/props_vehicles/truck001a.mdl" );

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

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Money" );
	self:NetworkVar( "Int", 1, "Team" );

	if( SERVER ) then
		self:SetMoney( 0 );
		self:SetTeam( 0 );
	end

end