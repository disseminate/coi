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

	local x, y = self:FindInvInsertPos( item );

	if( x and y ) then

		local id = self:SQLAddItem( item, x, y );

		self.Inventory[id] = {
			ItemClass = item,
			X = x,
			Y = y
		};

		net.Start( "nAddInventory" );
			net.WriteUInt( id, 16 );
			net.WriteString( item );
			net.WriteUInt( x, 6 );
			net.WriteUInt( y, 6 );
		net.Send( self );

	end

end
util.AddNetworkString( "nAddInventory" );

local function nBuyItem( len, ply )

	if( GAMEMODE:GetState() != STATE_PREGAME ) then return end

	local item = net.ReadString();

	ply:CheckInventory();

	if( !GAMEMODE.Items[item] ) then return end
	if( ply:HasItem( item ) ) then return end

	local i = GAMEMODE.Items[item];

	if( ply.Money >= i.Price ) then

		ply:AddMoney( -i.Price );
		ply:AddInventory( item );

	end

end
net.Receive( "nBuyItem", nBuyItem );
util.AddNetworkString( "nBuyItem" );

local function nInvMove( len, ply )

	ply:CheckInventory();
	local id = net.ReadUInt( 16 );

	if( !ply.Inventory[id] ) then return end

	local x = net.ReadUInt( 6 );
	local y = net.ReadUInt( 6 );

	if( !ply:CanPutItemInSlot( id, x, y ) ) then return end

	ply.Inventory[id].X = x;
	ply.Inventory[id].Y = y;

	ply:SQLMoveInventory( id, x, y );

end
net.Receive( "nInvMove", nInvMove );
util.AddNetworkString( "nInvMove" );