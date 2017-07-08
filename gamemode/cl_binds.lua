function GM:PlayerBindPress( ply, bind, down )

	if( down ) then
		
		if( bind == "+jump" and !LocalPlayer().Joined ) then

			LocalPlayer().Joined = true;
			net.Start( "nJoin" );
			net.SendToServer();

			return true;

		end

		if( bind == "invnext" or bind == "invprev" ) then -- only 2 weps!

			local wep = ply:GetActiveWeapon();
			if( wep and wep:IsValid() and wep != NULL ) then

				local tab = ply:GetWeapons();

				for k, v in pairs( tab ) do

					if( v != wep and !v.NoDraw ) then

						self.NextWeapon = v;

					end

				end

			end

			return true;

		end

		ply:CheckInventory();

		if( bind == "slot1" ) then

			for _, v in pairs( ply.Inventory ) do

				local item = self.Items[v.ItemClass];
				if( !item.Secondary and LocalPlayer():HasWeapon( item.SWEP ) ) then

					local wep = LocalPlayer():GetWeapon( item.SWEP );
					if( !wep.NoDraw ) then
						
						self.NextWeapon = wep;
						break;

					end

				end

			end

			return true;

		elseif( bind == "slot2" ) then

			for _, v in pairs( ply.Inventory ) do

				local item = self.Items[v.ItemClass];
				if( item.Secondary and LocalPlayer():HasWeapon( item.SWEP ) ) then

					local wep = LocalPlayer():GetWeapon( item.SWEP );
					if( !wep.NoDraw ) then
						
						self.NextWeapon = wep;
						break;

					end

				end

			end

			return true;

		end

	end

end

function GM:ChatText( idx, name, text, type )

	if( type == "servermsg" ) then return true end

end