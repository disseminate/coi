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

function ENT:GetClosestPlayer()

	local ply = nil;
	local closest = math.huge;

	for _, v in pairs( player.GetJoined() ) do

		local d = v:GetPos():Distance( self:GetPos() );
		if( d < closest ) then
			closest = d;
			ply = v;
		end
		
	end

	return ply;

end

function ENT:MoveToPlayer( ply )

	if( !ply or !ply:IsValid() ) then return "invalid ply" end

	local path = Path( "Chase" );
	path:SetMinLookAheadDistance( 300 );
	path:SetGoalTolerance( 200 );
	path:Compute( self, ply:GetPos() );

	if( !path:IsValid() ) then return "failed" end

	while( path:IsValid() ) do

		if( !self:CanTargetPlayer( ply ) ) then return "invalid ply" end

		path:Chase( self, ply );

		if( self.loco:IsStuck() ) then
			self:HandleStuck();
			return "stuck";
		end

		if( path:GetAge() > 0.3 ) then
			path:Compute( self, ply:GetPos() );

			local trace = { };
			trace.start = self:EyePos();
			trace.endpos = ply:EyePos();
			trace.filter = { self };
			local tr = util.TraceLine( trace );
			
			if( tr.Entity and tr.Entity:IsValid() and tr.Entity == ply and ( tr.HitPos - tr.StartPos ):Length() < self.AimDist ) then
				return "got player LOS"
			end
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:ShootAt( ply )

	local start = self:GetPos() + Vector( 0, 0, 60 );

	local bull = { };
	bull.Attacker = self;
	bull.Damage = 10 * ( 1 - ( math.Clamp( #player.GetJoined() / 20, 0, 1 ) * 0.8 ) );
	bull.Dir = ( ply:GetPos() + Vector( 0, 0, 44 ) - start ):GetNormal();
	bull.Spread = Vector( self.Accuracy, self.Accuracy, 0 );
	bull.Src = start;
	bull.IgnoreEntity = self;
	self:FireBullets( bull );

	self:EmitSound( Sound( "Weapon_Pistol.NPC_Single" ) );
	self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL );

end

function ENT:CanTargetPlayer( ply )

	if( !self:Alive() ) then return false end
	if( !ply or !ply:IsValid() ) then return false end
	if( !ply:Alive() ) then return false end
	if( ply.Safe ) then return false end
	if( ply.Unconscious ) then return false end

	return true;

end

function ENT:ShootAtPlayer( ply )

	if( !ply or !ply:IsValid() ) then return "invalid ply" end

	while( true ) do

		if( GAMEMODE:GetState() != STATE_GAME ) then return "bad state" end

		if( !self:CanTargetPlayer( ply ) ) then return "invalid ply" end

		self.loco:FaceTowards( ply:GetPos() );

		local trace = { };
		trace.start = self:EyePos();
		trace.endpos = ply:EyePos();
		trace.filter = { self };
		local tr = util.TraceLine( trace );

		if( tr.Fraction < 1.0 and ( !tr.Entity or !tr.Entity:IsValid() or tr.Entity != ply ) ) then

			return "lost player LOS";

		end

		if( ( tr.HitPos - tr.StartPos ):Length() >= self.AimDist ) then

			return "player too far";

		end

		if( !self.NextShot ) then

			self.NextShot = CurTime() + 1;

		end

		if( CurTime() >= self.NextShot ) then

			self.NextShot = CurTime() + math.Rand( 0.4, 0.8 );
			self:ShootAt( ply );

		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:BodyUpdate()

	local act = self:GetActivity();

	if( act == ACT_RUN or act == ACT_WALK or act == ACT_HL2MP_RUN ) then

		self:BodyMoveXY();

	end
	
	self:FrameAdvance();

end

function ENT:RunBehaviour()

	while( true ) do

		if( GAMEMODE:GetState() == STATE_GAME ) then

			local ply = self:GetClosestPlayer();

			if( self:CanTargetPlayer( ply ) ) then

				self:StartActivity( ACT_HL2MP_RUN );
				self.loco:SetDesiredSpeed( 250 );
				local ret = self:MoveToPlayer( ply );
				self:StartActivity( ACT_HL2MP_IDLE_REVOLVER );

				if( ply and ply:IsValid() ) then
					local ret = self:ShootAtPlayer( ply );
				end

				coroutine.wait( math.Rand( 0, 1 ) );
				coroutine.yield();

			else

				self:StartActivity( ACT_HL2MP_IDLE );
				coroutine.wait( math.Rand( 0, 1 ) );
				coroutine.yield();

			end

		else

			coroutine.yield();

		end

	end

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