function player.GetJoined()

	local tab = { };

	for _, v in pairs( player.GetAll() ) do

		if( v.Joined ) then

			table.insert( tab, v );

		end

	end

	return tab;

end

function GM:StartCommand( ply, cmd )

	if( !ply.Joined ) then
		cmd:ClearButtons();
		cmd:ClearMovement();
	end

	if( self:GetState() == STATE_PREGAME and false ) then -- TODO
		cmd:ClearButtons();
		cmd:ClearMovement();
	end

end

function GM:ShouldCollide( e1, e2 )

	if( e1:IsPlayer() and e2:IsPlayer() ) then return false end
	return self.BaseClass:ShouldCollide( e1, e2 );

end

function GM:AreTeamsUnbalanced()

	return !self:CanChangeTeam();

end

function GM:CanChangeTeam( cur, targ )

	if( self:GetState() == STATE_GAME ) then return false end
	if( cur == targ ) then return false end
	-- TODO
	return true;

end