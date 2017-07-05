function GM:CalcView( ply, origin, angles, fov, znear, zfar )

	local tab = table.Copy( self.BaseClass:CalcView( ply, origin, angles, fov, znear, zfar ) );

	if( ply.Safe or self:GetState() == STATE_PREGAME ) then

		local teams = self.Teams;
		if( !teams ) then return end
		if( !teams[ply:Team()] ) then return end
		if( !teams[ply:Team()].Truck or !teams[ply:Team()].Truck:IsValid() ) then return end

		local truck = teams[ply:Team()].Truck;
		local p0 = truck:GetPos();

		local x = 70;
		local y = 0;
		local z = 27;

		tab.origin = p0 + truck:GetForward() * x + truck:GetRight() * y + truck:GetUp() * z;
		tab.angles = ( p0 - tab.origin ):Angle();

	end

	return tab;

end

function GM:ShouldDrawLocalPlayer( ply )

	if( ply.Safe ) then return true end
	if( self:GetState() == STATE_PREGAME ) then return true end
	return false;

end