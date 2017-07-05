include( "shared.lua" );

function ENT:Draw()

	self:DrawModel();
	
	

	if( #player.GetJoined() == 0 ) then return end
	if( GAMEMODE:GetState() != STATE_GAME ) then return end

	local cang = self:GetAngles();
	cang:RotateAroundAxis( self:GetUp(), -90 );
	cang:RotateAroundAxis( self:GetRight(), 90 );

	cam.Start3D2D( self:GetPos() + self:GetUp() * 20 + self:GetForward() * -120, cang, 0.125 );

		local y;
	
		if( self:GetTeam() > 0 ) then
			
			surface.SetFont( "COI Title 64" );
			local n = team.GetName( self:GetTeam() );
			local w, h = surface.GetTextSize( n );
			
			surface.SetTextPos( -w / 2, -h / 2 );
			surface.SetTextColor( team.GetColor( self:GetTeam() ) );
			surface.DrawText( n );

			y = h / 2;

		end

		surface.SetFont( "COI Title 128" );
		local n = "$" .. string.Comma( self:GetMoney() );
		surface.SetTextColor( GAMEMODE:GetSkin().COLOR_MONEY );
		local w, h = surface.GetTextSize( n );
		surface.SetTextPos( -w / 2, y and y + 10 or -h / 2 );
		surface.DrawText( n );
				
	cam.End3D2D();

end

function ENT:RenderOverride()

	self:DrawModel();

	if( LocalPlayer().HasMoney and self:GetTeam() == LocalPlayer():Team() ) then

		render.ClearStencil();
		render.SetStencilEnable( true );

			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS );
			render.SetStencilPassOperation( STENCILOPERATION_INCRSAT );
			render.SetStencilFailOperation( STENCILOPERATION_KEEP );
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP );

				self:DrawModel();

			render.SetStencilReferenceValue( 1 );
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL );
			
				render.SetMaterial( GAMEMODE:GetSkin().MAT_GREEN );
				render.DrawScreenQuad();

		render.SetStencilEnable( false );

	end

end

local function nMsgWrongTruck( len )

	chat.AddText( GAMEMODE:GetSkin().COLOR_WHITE, "Wrong truck! You're looking for the truck with the same color as ", team.GetColor( LocalPlayer():Team() ), team.GetName( LocalPlayer():Team() ), GAMEMODE:GetSkin().COLOR_WHITE, "." );

end
net.Receive( "nMsgWrongTruck", nMsgWrongTruck );

local function nMsgTruckDeposit( len )

	local amt = net.ReadUInt( 32 );

	chat.AddText( GAMEMODE:GetSkin().COLOR_WHITE, "Nice work. You earned ", GAMEMODE:GetSkin().COLOR_MONEY, "$" .. string.Comma( amt ), GAMEMODE:GetSkin().COLOR_WHITE, " for your team." );

end
net.Receive( "nMsgTruckDeposit", nMsgTruckDeposit );