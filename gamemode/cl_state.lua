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

		v.Cloaked = nil;

		v:Freeze( false );

	end

	LocalPlayer().Consciousness = 100;

	self:ResetMapTrucks();

end

local function nSendStats( len )

	GAMEMODE.Stats = { };
	GAMEMODE.Stats.MostBags = net.ReadEntity();
	GAMEMODE.Stats.MostKills = net.ReadEntity();
	GAMEMODE.Stats.MostKnockouts = net.ReadEntity();
	GAMEMODE.Stats.MostCops = net.ReadEntity();
	GAMEMODE.Stats.Bags = net.ReadUInt( 16 );
	GAMEMODE.Stats.Kills = net.ReadUInt( 16 );
	GAMEMODE.Stats.Knockouts = net.ReadUInt( 16 );
	GAMEMODE.Stats.Cops = net.ReadUInt( 16 );

end
net.Receive( "nSendStats", nSendStats );
