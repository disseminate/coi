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

		v.Unconscious = false;
		v.UnconsciousTime = nil;
		v.Consciousness = 100;

		v:StripWeapons();
		v:Spawn();

	end

	for k, v in pairs( self.Teams ) do

		team.SetScore( k, 0 );

	end

	game.CleanUpMap();

	self:ResetMapTrucks();

end

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
	
	net.Start( "nSendStats" );
		net.WriteEntity( bags );
	net.Broadcast();

end
util.AddNetworkString( "nSendStats" );