local meta = FindMetaTable( "Player" );
GM.Items = RequireDir( "items" );

function meta:CheckInventory()

	if( !self.Inventory ) then
		self.Inventory = { };
	end

end

function meta:InvW()

	return 16;

end

function meta:InvH()

	return 6;

end

function meta:InvOccupied( x0, y0, filter )

	self:CheckInventory();

	if( x0 <= 0 ) then return true end
	if( y0 <= 0 ) then return true end

	for k, v in pairs( self.Inventory ) do

		local x = v.X;
		local y = v.Y;
		local item = GAMEMODE.Items[v.ItemClass];
		local w = item.W;
		local h = item.H;

		if( x0 >= x and x0 < x + w and y0 >= y and y0 < y + h and k != filter ) then return true end

	end

	return false;

end

function meta:FindInvInsertPos( itemclass )

	local item = GAMEMODE.Items[itemclass];

	for j = 1, self:InvH() - item.H do

		for i = 1, self:InvW() - item.W do

			local unoccupied = true;

			for ii = 1, item.W do

				for jj = 1, item.H do

					if( self:InvOccupied( i + ii - 1, j + jj - 1 ) ) then

						unoccupied = false;

					end

				end

			end

			if( unoccupied ) then

				return i, j;

			end

		end

	end

end

function meta:HasItem( class )

	self:CheckInventory();

	for k, v in pairs( self.Inventory ) do

		if( v.ItemClass == class ) then return true end

	end

	return false;

end

function meta:CanPutItemInSlot( id, x, y )

	self:CheckInventory();

	local itemclass = self.Inventory[id].ItemClass
	local item = GAMEMODE.Items[itemclass];

	local unoccupied = true;

	if( x + item.W - 1 > self:InvW() ) then return false end
	if( y + item.H - 1 > self:InvH() ) then return false end
	if( x <= 0 ) then return false end
	if( y <= 0 ) then return false end

	for ii = 1, item.W do

		for jj = 1, item.H do

			if( self:InvOccupied( x + ii - 1, y + jj - 1, id ) ) then

				return false;

			end

		end

	end

	return true;

end