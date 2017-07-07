local meta = FindMetaTable( "Player" );

function meta:AddMoney( amt )

	if( !self.Money ) then -- ?

		self.Money = amt;
		return;

	end

	self.Money = self.Money + amt;
	sql.Query( "UPDATE coi_players SET Money = " .. self.Money .. " WHERE ID = " .. self.ID .. ";" );

	net.Start( "nSetMoney" );
		net.WriteUInt( self.Money, 32 );
	net.Send( self );

end

function GM:SendStateMoney()

	for k, v in pairs( self.Teams ) do

		local amtTotal = team.GetScore( k );

		local nPlayers = 0;

		for _, n in pairs( team.GetPlayers( k ) ) do

			if( n.Safe ) then

				nPlayers = nPlayers + 1;

			end

		end

		local amt = math.floor( amtTotal / nPlayers );

		for _, n in pairs( team.GetPlayers( k ) ) do

			if( n.Safe ) then

				n:AddMoney( amt );

			end

		end

	end

end

function meta:AddInventory( item )

	self:CheckInventory();

	if( table.HasValue( self.Inventory, item ) ) then return end

	table.insert( self.Inventory, item );
	self:SQLAddItem( item );

	net.Start( "nAddInventory" );
		net.WriteString( item );
	net.Send( self );

end
util.AddNetworkString( "nAddInventory" );

local function nBuyItem( len, ply )

	if( GAMEMODE:GetState() != STATE_PREGAME ) then return end

	local item = net.ReadString();

	ply:CheckInventory();

	if( !GAMEMODE.Items[item] ) then return end
	if( table.HasValue( ply.Inventory, item ) ) then return end

	local i = GAMEMODE.Items[item];

	if( ply.Money >= i.Price ) then

		ply:AddMoney( -i.Price );
		ply:AddInventory( item );

	end

end
net.Receive( "nBuyItem", nBuyItem );
util.AddNetworkString( "nBuyItem" );