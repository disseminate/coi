local function nReceiveState( len )

	GAMEMODE.StateCycleStart = net.ReadFloat();

end
net.Receive( "nReceiveState", nReceiveState );

local function nJoin( len )

	local ply = net.ReadEntity();
	ply.Joined = true;

end
net.Receive( "nJoin", nJoin );

function GM:Reset()
	
	for _, v in pairs( player.GetAll() ) do

		v.HasMoney = false;
		v.Safe = false;

		v.Unconscious = false;
		v.UnconsciousTime = nil;

		v:Freeze( false );

	end

	LocalPlayer().Consciousness = 100;

	self:ResetMapTrucks();

end

local function nSendStats( len )

	local bags = net.ReadEntity();

	GAMEMODE.Stats = { };
	GAMEMODE.Stats.MostBags = bags;

end
net.Receive( "nSendStats", nSendStats );