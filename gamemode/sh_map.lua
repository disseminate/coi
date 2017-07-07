local meta = FindMetaTable( "Player" );

function meta:GetTruck()

	local teams = GAMEMODE.Teams;
	if( teams and teams[self:Team()] and teams[self:Team()].Truck and teams[self:Team()].Truck:IsValid() ) then

		return teams[self:Team()].Truck;

	end

end

function meta:GetBagMoney()

	for k, v in pairs( GAMEMODE.Teams ) do

		if( team.NumPlayers( k ) == 0 ) then

			return 20, 50;

		end

	end

	local count = team.GetCount( self:Team() );

	-- More players on my team means more hands
	local min = math.floor( 200 / count );
	local max = math.floor( 500 / count );

	-- More players in total means more difficulty though
	-- Scale to team disparities by comparing team size to all players
	local c = #player.GetJoined();
	min = min * ( c / #self.Teams );
	max = max * ( c / #self.Teams );

	return min, max;

end