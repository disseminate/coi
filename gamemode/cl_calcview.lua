function GM:CalcView( ply, origin, angles, fov, znear, zfar )

	local tab = table.Copy( self.BaseClass:CalcView( ply, origin, angles, fov, znear, zfar ) );

	if( ply.Unconscious ) then

		local rad = 128;
		local ang = CurTime() * 0.1;

		local x = math.cos( ang ) * rad;
		local y = math.sin( ang ) * rad;
		local z = 40;

		local pos = tab.origin + Vector( x, y, z );
		local opos = tab.origin;

		tab.origin = pos;
		tab.angles = ( opos - pos ):Angle();

	elseif( ply:ShouldRenderInTruck() ) then

		local truck = ply:GetTruck();
		if( truck and truck:IsValid() ) then

			local p0 = truck:GetPos();

			local x = 70;
			local y = 0;
			local z = 27;

			tab.origin = p0 + truck:GetForward() * x + truck:GetRight() * y + truck:GetUp() * z;
			tab.angles = ( p0 - tab.origin ):Angle();

		end

	else

		local vel = ply:GetVelocity():Dot( ply:GetRight() ) / ply:GetRunSpeed();
		tab.angles.r = vel * 2.5;

	end

	if( self.CamPos ) then
	
		if( !ply.Joined ) then

			tab.origin = self.CamPos[1];
			tab.angles = self.CamPos[2];

			return tab;

		else

			if( !ply.JoinTweenStart ) then
				ply.JoinTweenStart = CurTime();
			end

			local d = math.EaseInOut( math.Clamp( CurTime() - ply.JoinTweenStart, 0, 1 ) / 1, 0, 1 );

			tab.origin = LerpVector( d, self.CamPos[1], tab.origin );
			tab.angles = LerpAngle( d, self.CamPos[2], tab.angles );

			return tab;

		end

	end

	return tab;

end

function GM:ShouldDrawLocalPlayer( ply )

	if( ply.Safe ) then return true end
	if( ply.Unconscious ) then return true end
	if( self:GetState() == STATE_PREGAME ) then return true end
	return false;

end