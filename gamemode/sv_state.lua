local meta = FindMetaTable( "Player" );

function GM:ResetState()

	self.StateCycleStart = CurTime();

	self:BroadcastState();

end

function GM:BroadcastState()

	if( !self.StateCycleStart ) then return end
	
	net.Start( "nReceiveState" );
		net.WriteFloat( self.StateCycleStart );
	net.Broadcast();

end
util.AddNetworkString( "nReceiveState" );

function meta:SendState()

	if( !GAMEMODE.StateCycleStart ) then return end

	net.Start( "nReceiveState" );
		net.WriteFloat( GAMEMODE.StateCycleStart );
	net.Send( self );

end

function GM:OnReloaded()

	self:BroadcastState();

end

function GM:Reset()

	for _, v in pairs( player.GetAll() ) do

		v.HasMoney = false;
		v.Safe = false;

		v.Bags = 0;
		v.Kills = 0;
		v.Knockouts = 0;
		v.Cops = 0;

		v.Unconscious = false;
		v.UnconsciousTime = nil;
		v.Consciousness = 100;

		v.PrimaryLoadout = nil;
		v.SecondaryLoadout = nil;

		v.Cloaked = nil;

		v.ActiveWep = nil;

		v:StripWeapons();
		v:Spawn();

	end

	for k, v in pairs( self.Teams ) do

		team.SetScore( v, 0 );

	end

	game.CleanUpMap();

	self:ResetMapTrucks();

end
util.AddNetworkString( "nResetTrucks" );

function GM:DebugAdvanceTime( amt )

	self.StateCycleStart = self.StateCycleStart - amt;

	net.Start( "nReceiveState" );
		net.WriteFloat( self.StateCycleStart );
	net.Broadcast();

end

function GM:SendStats()

	if( #player.GetJoined() == 0 ) then return end

	local bags = player.GetJoined()[1];
	local bagsMax = 0;

	for _, v in pairs( player.GetJoined() ) do

		if( v.Bags and v.Bags > bagsMax ) then

			bagsMax = v.Bags;
			bags = v;

		end

	end

	local kills = player.GetJoined()[1];
	local killsMax = 0;

	for _, v in pairs( player.GetJoined() ) do

		if( v.Kills and v.Kills > killsMax ) then

			killsMax = v.Kills;
			kills = v;

		end

	end

	local knocks = player.GetJoined()[1];
	local knocksMax = 0;

	for _, v in pairs( player.GetJoined() ) do

		if( v.Knockouts and v.Knockouts > knocksMax ) then

			knocksMax = v.Knockouts;
			knocks = v;

		end

	end

	local cops = player.GetJoined()[1];
	local copsMax = 0;

	for _, v in pairs( player.GetJoined() ) do

		if( v.Cops and v.Cops > copsMax ) then

			copsMax = v.Cops;
			cops = v;

		end

	end

	--Knockouts
	
	net.Start( "nSendStats" );
		net.WriteEntity( bags );
		net.WriteEntity( kills );
		net.WriteEntity( knocks );
		net.WriteEntity( cops );
		net.WriteUInt( bagsMax, 16 );
		net.WriteUInt( killsMax, 16 );
		net.WriteUInt( knocksMax, 16 );
		net.WriteUInt( copsMax, 16 );
	net.Broadcast();

end
util.AddNetworkString( "nSendStats" );