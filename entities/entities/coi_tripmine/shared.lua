ENT.Base = "base_anim";
ENT.Type = "anim";

function ENT:Initialize()

	self:SetModel( "models/weapons/w_slam.mdl" );

	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER );

	self:UseTriggerBounds( true, 24 );

	if( SERVER ) then

		self.TripmineOnTime = CurTime() + 1;
		self:EmitSound( Sound( "weapons/slam/mine_mode.wav" ) );

	else

		self:SetRenderBounds( Vector( -16, -16, 0 ), Vector( 16, 16, 32768 ) );

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Player" );
	self:NetworkVar( "Bool", 0, "TripmineOn" );

end