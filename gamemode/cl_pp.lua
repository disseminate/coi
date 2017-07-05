function GM:PreDrawViewModel()

	if( LocalPlayer().HasMoney ) then
		
		if( !self.MoneyViewmodel or !self.MoneyViewmodel:IsValid() ) then
			self.MoneyViewmodel = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_VIEWMODEL );
			self.MoneyViewmodel:SetRenderBounds( Vector( -256, -256, -256 ), Vector( 256, 256, 256 ) );
			self.MoneyViewmodel.m_vecLastFacing = EyePos();
		end

		local f = EyeAngles():Forward();
		local r = EyeAngles():Right();
		local u = EyeAngles():Up();

		local pos = EyePos() + f * 20 + r * 9 + u * -12;

		local ang = EyeAngles();
		ang:RotateAroundAxis( r, -110 );

		if( !self.MoneyViewmodel.m_vecLastFacing ) then
			self.MoneyViewmodel.m_vecLastFacing = EyePos();
		end
		
		local vDifference = self.MoneyViewmodel.m_vecLastFacing - f;
		
		local flSpeed = 7;
		
		local flDiff = vDifference:Length();
		if( flDiff > 1.5 ) then
			
			flSpeed = flSpeed * ( flDiff / 1.5 );
			
		end
		
		vDifference:Normalize();
		
		self.MoneyViewmodel.m_vecLastFacing = self.MoneyViewmodel.m_vecLastFacing + vDifference * flSpeed * FrameTime();
		self.MoneyViewmodel.m_vecLastFacing:Normalize();
		local newPos = pos + ( vDifference * -1 ) * 5;

		self.MoneyViewmodel:SetPos( newPos );
		self.MoneyViewmodel:SetRenderOrigin( newPos );
		self.MoneyViewmodel:SetRenderAngles( ang );
			self.MoneyViewmodel:DrawModel();

	elseif( self.MoneyViewmodel ) then

		self.MoneyViewmodel:Remove();
		self.MoneyViewmodel = nil;

	end

end
