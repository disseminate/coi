ENT.Base = "base_nextbot";

function ENT:Initialize()

	self:SetModel( "models/player/swat.mdl" );

	self.AimDist = math.Rand( 500, 700 );
	self.Accuracy = 0.06;

	if( SERVER ) then

		self:SetCustomCollisionCheck( true );
		self:SetHealth( math.random( 10, 20 ) );

	end

	--self:PhysicsInitShadow( true, false );

end

function ENT:BodyUpdate()

	local act = self:GetActivity();

	if( act == ACT_RUN or act == ACT_WALK or act == ACT_HL2MP_RUN ) then

		self:BodyMoveXY();

	end
	
	self:FrameAdvance();

end

function ENT:OnKilled( dmg )

	self:BecomeRagdoll( dmg );
	self:SetAlive( false );

end

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Alive" );

	if( SERVER ) then
		self:SetAlive( true );
	end

end

function ENT:Alive()
	return self:GetAlive();
end