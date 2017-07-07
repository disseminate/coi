local function nSetMoney( len )

	local amt = net.ReadUInt( 32 );

	LocalPlayer().Money = amt;

end
net.Receive( "nSetMoney", nSetMoney );

local function nSetInventory( len )

	LocalPlayer().Inventory = { };

	local n = net.ReadUInt( 8 );

	for i = 1, n do

		local str = net.ReadString();
		table.insert( LocalPlayer().Inventory, str );

	end

	GAMEMODE:ResetLoadoutInventory();

end
net.Receive( "nSetInventory", nSetInventory );

local function nAddInventory( len )

	LocalPlayer():CheckInventory();

	local item = net.ReadString();

	if( table.HasValue( LocalPlayer().Inventory, item ) ) then return end

	table.insert( LocalPlayer().Inventory, item );

	GAMEMODE:ResetLoadoutInventory();

end
net.Receive( "nAddInventory", nAddInventory );