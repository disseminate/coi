local meta = FindMetaTable( "Player" );

function meta:CheckInventory()

	if( !self.Inventory ) then
		self.Inventory = { };
	end

end