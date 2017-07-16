function GM:PlayerBindPress( ply, bind, down )

	if( down ) then
		
		if( bind == "+jump" and !LocalPlayer().Joined ) then

			LocalPlayer().Joined = true;
			net.Start( "nJoin" );
			net.SendToServer();

			return true;

		end

		if( bind == "gm_showhelp" ) then

			self:ShowHelp();
			return true;

		end

		if( bind == "+menu_context" ) then

			self:CreateSettingsPanel();
			return true;

		end

		if( bind == "invnext" or bind == "invprev" ) then -- only 2 weps!

			local add = 1;
			if( bind == "invprev" ) then
				add = -1;
			end

			local tab = ply:GetWeapons();
			local wep = ply:GetActiveWeapon();
			if( wep and wep:IsValid() and wep != NULL ) then

				local cur;
				for k, v in pairs( tab ) do

					if( v == wep ) then

						cur = k;
						break;

					end

				end

				if( cur ) then

					local slot = cur + add;
					if( slot < 1 ) then
						self.NextWeapon = tab[#tab];
					elseif( slot > #tab ) then
						self.NextWeapon = tab[1];
					else
						self.NextWeapon = tab[slot];
					end

				end

			else

				if( #tab > 0 ) then

					self.NextWeapon = tab[1];

				end

			end

			return true;

		end

		ply:CheckInventory();

		local p, l = string.find( bind, "slot" );
		if( p == 1 ) then

			local slotNum = tonumber( string.sub( bind, p + l ) );
			local sweps = ply:GetWeapons();

			if( sweps[slotNum] ) then
				self.NextWeapon = sweps[slotNum];
				return true;
			end

		end

	end

end

function GM:ChatText( idx, name, text, type )

	if( type == "servermsg" ) then return true end

end