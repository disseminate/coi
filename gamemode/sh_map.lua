local meta = FindMetaTable( "Player" );

function meta:GetTruck()

	local teams = GAMEMODE.Teams;
	if( teams and teams[self:Team()] and teams[self:Team()].Truck and teams[self:Team()].Truck:IsValid() ) then

		return teams[self:Team()].Truck;

	end

end