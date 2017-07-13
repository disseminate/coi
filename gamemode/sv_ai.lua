function GM:CheckNavmesh()

	navmesh.Load();

	if( navmesh.IsLoaded() ) then
		self.HasNavmesh = true;
		MsgN( "Navmesh loaded (" .. #navmesh.GetAllNavAreas() .. " areas)" );
		return;
	end

	self:GenerateNavmesh();

end

function GM:GenerateNavmesh()

	navmesh.Reset();
	navmesh.ClearWalkableSeeds();

	for _, v in pairs( ents.FindByClass( "coi_copspawner" ) ) do

		navmesh.AddWalkableSeed( v:GetPos(), Vector( 0, 0, 1 ) );

	end

	navmesh.BeginGeneration();

end

function GM:GetCops()

	return ents.FindByClass( "coi_cop" );

end

function GM:GetAISpawnpoint()

	local ent = table.Random( ents.FindByClass( "coi_copspawner" ) );

	if( ent and ent:IsValid() ) then

		return ent:GetPos();

	end

end

function GM:AIThink()

	if( self:GetState() != STATE_GAME ) then return end
	if( #self:GetCops() >= math.Clamp( #player.GetJoined() * 2, 0, 10 ) ) then return end

	local t = STATE_TIMES[STATE_GAME] - self:TimeLeftInState();

	local timeNPCsStart = 3;

	if( t < 60 * timeNPCsStart ) then return end

	if( !self.NextAISpawn ) then
		self.NextAISpawn = CurTime() + math.Rand( 1, 5 );
	end

	if( CurTime() >= self.NextAISpawn ) then

		local minRate = ( 1 / #player.GetJoined() ) * ( 20 / 3 );
		local maxRate = ( 1 / #player.GetJoined() ) * 2;
		local mul = ( t - 60 * timeNPCsStart ) / ( STATE_TIMES[STATE_GAME] - 60 * timeNPCsStart );

		self.NextAISpawn = CurTime() + Lerp( mul, minRate, maxRate );

		local spawnPos = self:GetAISpawnpoint();

		if( spawnPos ) then

			local e = ents.Create( "coi_cop" );
			e:SetPos( spawnPos );
			e:SetAngles( Angle( 0, math.Rand( -180, 180 ), 0 ) );
			e:Spawn();
			e:Activate();

		end

	end

end