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