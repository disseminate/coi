function GM:CalcMainActivity( ply, vel )

	local ideal, override = self.BaseClass:CalcMainActivity( ply, vel );

	if( ply.Safe or self:GetState() == STATE_PREGAME ) then

		return ACT_HL2MP_SIT, -1;

	end

	return ideal, override;

end

function GM:UpdateAnimation( ply, vel, ms )

	self.BaseClass:UpdateAnimation( ply, vel, ms );

end
