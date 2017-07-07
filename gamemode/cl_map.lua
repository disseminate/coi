function GM:InitPostEntity()

	self:InitializeTeams();

end

local function nMapData( len )

	local pos = net.ReadVector();
	local ang = net.ReadAngle();

	GAMEMODE.CamPos = {
		pos,
		ang
	};

end
net.Receive( "nMapData", nMapData );