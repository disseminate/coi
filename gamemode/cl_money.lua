local function nSetMoney( len )

	local amt = net.ReadUInt( 32 );

	LocalPlayer().Money = amt;

end
net.Receive( "nSetMoney", nSetMoney );

local function nSetInventory( len )

	LocalPlayer().Inventory = { };

	local n = net.ReadUInt( 8 );

	for i = 1, n do

		local id = net.ReadUInt( 16 );
		local str = net.ReadString();
		local x = net.ReadUInt( 6 );
		local y = net.ReadUInt( 6 );

		LocalPlayer().Inventory[id] = {
			ItemClass = str,
			X = x,
			Y = y
		};

	end

	GAMEMODE:ResetLoadoutInventory();

end
net.Receive( "nSetInventory", nSetInventory );

local function nAddInventory( len )

	LocalPlayer():CheckInventory();

	local id = net.ReadUInt( 16 );
	local item = net.ReadString();
	local x = net.ReadUInt( 6 );
	local y = net.ReadUInt( 6 );

	LocalPlayer().Inventory[id] = {
		ItemClass = item,
		X = x,
		Y = y
	};

	GAMEMODE:ResetLoadoutInventory();

end
net.Receive( "nAddInventory", nAddInventory );