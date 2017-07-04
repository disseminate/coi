function GM:PlayerBindPress( ply, bind, down )

	if( down ) then
		
		if( bind == "+jump" and !LocalPlayer().Joined ) then

			LocalPlayer().Joined = true;
			net.Start( "nJoin" );
			net.SendToServer();

			return true;

		end

	end

end

function GM:ChatText( idx, name, text, type )

	if( type == "servermsg" ) then return true end

end