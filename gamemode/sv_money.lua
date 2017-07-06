local meta = FindMetaTable( "Player" );

function meta:AddMoney( amt )

	if( !self.Money ) then -- ?

		self.Money = amt;
		return;

	end

	self.Money = self.Money + amt;
	sql.Query( "UPDATE coi_players SET Money = " .. self.Money .. " WHERE ID = " .. self.ID .. ";" );

	net.Start( "nSetMoney" );
		net.WriteUInt( self.Money, 32 );
	net.Send( self );

end

function GM:SendStateMoney()

	for k, v in pairs( self.Teams ) do

		local amtTotal = team.GetScore( k );

		local nPlayers = 0;

		for _, n in pairs( team.GetPlayers( k ) ) do

			if( n.Safe ) then

				nPlayers = nPlayers + 1;

			end

		end

		local amt = math.floor( amtTotal / nPlayers );

		for _, n in pairs( team.GetPlayers( k ) ) do

			if( n.Safe ) then

				n:AddMoney( amt );

			end

		end

	end

end