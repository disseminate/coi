function GM:GetState()

	if( !self.StateCycleStart ) then
		return STATE_PREGAME;
	end

	local t = ( CurTime() - self.StateCycleStart ) % ( STATE_TIMES[STATE_PREGAME] + STATE_TIMES[STATE_GAME] + STATE_TIMES[STATE_POSTGAME] );
	
	if( t < STATE_TIMES[STATE_PREGAME] ) then
		return STATE_PREGAME;
	elseif( t >= STATE_TIMES[STATE_PREGAME] and t < STATE_TIMES[STATE_PREGAME] + STATE_TIMES[STATE_GAME] ) then
		return STATE_GAME;
	else
		return STATE_POSTGAME;
	end

end

function GM:TimeLeftInState()

	if( !self.StateCycleStart ) then
		return 0;
	end

	local state = self:GetState();

	local state = self:GetState();
	local el = ( CurTime() - self.StateCycleStart ) % ( STATE_TIMES[STATE_PREGAME] + STATE_TIMES[STATE_GAME] + STATE_TIMES[STATE_POSTGAME] );

	if( state == STATE_PREGAME ) then
		return STATE_TIMES[STATE_PREGAME] - el;
	elseif( state == STATE_GAME ) then
		return STATE_TIMES[STATE_GAME] - ( el - STATE_TIMES[STATE_PREGAME] );
	else
		return STATE_TIMES[STATE_POSTGAME] - ( el - STATE_TIMES[STATE_PREGAME] - STATE_TIMES[STATE_GAME] );
	end

end

function GM:StateThink()
	
	if( CLIENT and !LocalPlayer().Joined ) then return end

	local s = self:GetState();
	if( s == self.CacheState ) then
		return;
	end

	self:OnStateTransition( s, self.CacheState );
	self.CacheState = s;

end

function GM:OnStateTransition( state, oldstate )

	if( CLIENT ) then

		if( state == STATE_GAME and oldstate == STATE_PREGAME ) then
			
			if( self.Loadout and self.Loadout:IsValid() ) then
				self.Loadout:FadeOut();
			end

		end

		if( state == STATE_PREGAME ) then
			
			self:CreateLoadoutPanel();

		end

	end

end

function GM:InitializeTeams()

	local trucks = ents.FindByClass( "coi_truck" );
	local n = #trucks;

	if( !self.Trucks ) then
		self.Trucks = trucks;
	end

	for k, v in pairs( trucks ) do

		team.SetUp( k, "Crew #" .. k, HSVToColor( ( k - 1 ) * 70, 0.5, 1 ) );

	end

	team.SetUp( TEAM_UNJOINED, "Unjoined", Color( 128, 128, 128 ), false );

end