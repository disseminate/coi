local meta = FindMetaTable( "Player" );

function meta:GetTruck()

	for _, v in pairs( ents.FindByClass( "coi_truck" ) ) do

		if( v.GetTeam and v:GetTeam() == self:Team() ) then

			return v;

		end

	end

end

function meta:GetSpawnPos()

	local truck = self:GetTruck();
	if( truck and truck:IsValid() ) then

		return truck:GetPos() + truck:GetForward() * -180;

	end

end

function meta:GetBagMoney()

	for k, v in pairs( GAMEMODE.Teams ) do

		if( team.NumPlayers( v ) == 0 ) then

			return 20, 50;

		end

	end

	local count = team.NumPlayers( self:Team() );

	-- More players on my team means more hands
	local min = math.floor( 200 / count );
	local max = math.floor( 500 / count );

	-- More players in total means more difficulty though
	-- Scale to team disparities by comparing team size to all players
	local c = #player.GetJoined();
	min = min * ( c / #GAMEMODE.Teams );
	max = max * ( c / #GAMEMODE.Teams );

	return math.floor( min ), math.floor( max );

end