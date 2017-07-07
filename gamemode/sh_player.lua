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

	if( self:GetState() == STATE_PREGAME ) then
		cmd:ClearButtons();
		cmd:ClearMovement();
	end

	if( ply.Unconscious ) then
		cmd:ClearButtons();
		cmd:ClearMovement();
	end

	if( ply.Safe ) then
		local fl = cmd:GetButtons();
		if( bit.band( fl, IN_USE ) == IN_USE ) then
			cmd:SetButtons( IN_USE );
		else
			cmd:ClearButtons();
		end

		cmd:ClearMovement();
	end

end

function GM:ShouldCollide( e1, e2 )

	if( e1:IsPlayer() and e2:IsPlayer() ) then return false end
	
	if( e1:IsPlayer() and e1.Unconscious ) then return false end
	if( e2:IsPlayer() and e2.Unconscious ) then return false end

	return self.BaseClass:ShouldCollide( e1, e2 );

end

function GM:AreTeamsUnbalanced()

	return !self:CanChangeTeam();

end

function GM:CanChangeTeam( cur, targ )

	if( !self.Teams ) then return false end
	if( !table.HasValue( self.Teams, targ ) ) then return false end -- No changing to unconnected/etc teams

	if( self:GetState() == STATE_GAME ) then return false end
	if( cur == targ ) then return false end
	
	local diff = team.NumPlayers( targ ) - team.NumPlayers( cur );

	-- Can always join teams with less players
	-- Can't join teams with more
	if( diff > 0 ) then return false end

	return true;

end