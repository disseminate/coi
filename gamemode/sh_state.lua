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

	if( CLIENT ) then
		
		if( s == STATE_PREGAME ) then

			if( self:TimeLeftInState() <= 29.8 and !self.PlayedIntroSong ) then -- delay because game.CleanUpMap() resets it
				self.PlayedIntroSong = true;
				if( self:GetSetting( "music", 1 ) == 1 ) then
					surface.PlaySound( Sound( "coi/music/intro.wav" ) );
				end
			end

		elseif( s == STATE_POSTGAME ) then

			if( !self.PlayedEndingSong ) then
				self.PlayedEndingSong = true;
				if( self:GetSetting( "music", 1 ) == 1 ) then
					surface.PlaySound( Sound( "coi/music/ending.wav" ) );
				end
			end

		else

			self.PlayedIntroSong = nil;
			self.PlayedEndingSong = nil;

		end

	end

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

		elseif( state == STATE_POSTGAME ) then

			self:HUDResetGameOver();

		end

	else

		if( state == STATE_GAME and oldstate == STATE_PREGAME ) then

			self:Loadout( true );

		end

		if( state == STATE_POSTGAME ) then

			self:SendStateMoney();
			self:SendStats();

		end

	end

	if( state == STATE_PREGAME and oldstate == STATE_POSTGAME ) then

		self:Reset();

	end

end

function GM:ResetMapTrucks()

	local trucks = ents.FindByClass( "coi_truck" );
	self.Teams = { };
	
	for k, v in pairs( trucks ) do

		if( SERVER ) then
			v:SetTeam( k );
		end

		table.insert( self.Teams, k );
		
	end

end

local teamNames = {
	"Lion",
	"Crocodile",
	"Bear",
	"Stallion",
	"Wasp",
	"Cobra",
	"Mosquito",
	"Scorpion",
	"Union",
	"Sexsmith",
	"Lambda",
	"Omega",
	"Hunter",
	"Blade",
	"Scar",
	"Hammer",
	"Fist",
	"Razor",
	"Stab",
	"Dagger",
	"Reaper",
	"Nomad",
	"Star",
	"Phantom",
	"12th Street"
};

local gangNames = {
	"Crew",
	"Team",
	"Squad",
	"Family",
	"Saints",
	"Kings",
	"Mafia",
	"Mob",
	"Circle",
	"Nation"
};

function GM:InitializeTeams()

	self:ResetMapTrucks();

	-- New team name per day.
	math.randomseed( 1499450893 + tonumber( os.date( "%j", math.floor( os.time() - CurTime() ) ) ) );

	for k, v in pairs( self.Teams ) do

		team.SetUp( v, table.Random( teamNames ) .. " " .. table.Random( gangNames ), HSVToColor( ( v - 1 ) * 70, 0.5, 1 ) );

	end

	math.randomseed( os.time() );

	team.SetUp( TEAM_UNJOINED, "Unjoined", Color( 128, 128, 128 ), false );

end

function GM:InRushPeriod()

	return self:GetState() == STATE_GAME and self:TimeLeftInState() <= 60;

end