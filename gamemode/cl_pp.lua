function GM:PreDrawOpaqueRenderables( depth, sky )
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v.HasMoney ) then

			if( v == LocalPlayer() ) then
				
				if( !self.MoneyViewmodel or !self.MoneyViewmodel:IsValid() ) then
					self.MoneyViewmodel = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_VIEWMODEL );
					self.MoneyViewmodel:SetRenderBounds( Vector( -256, -256, -256 ), Vector( 256, 256, 256 ) );
					self.MoneyViewmodel.m_vecLastFacing = EyePos();

					self.MoneyViewmodel.RenderOverride = function()

						local wep = LocalPlayer():GetActiveWeapon();
						if( LocalPlayer().HasMoney ) then
							self.MoneyViewmodel:DrawModel();
						end

					end;
				end

				local f = EyeAngles():Forward();
				local r = EyeAngles():Right();
				local u = EyeAngles():Up();

				local pos = EyePos() + f * 20 + r * -8 + u * -15;

				local ang = EyeAngles();
				ang:RotateAroundAxis( r, -110 );
				ang:RotateAroundAxis( f, 20 );

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

				-- CBaseHL2MPCombatWeapon::AddViewmodelBob
				local f = ang:Forward();
				local r = ang:Right();

				local verticalBob, lateralBob = self:CalcViewmodelBob();

				local origin = newPos + f * verticalBob * 0.1;
				origin.z = origin.z + verticalBob * 0.1;

				ang.r = ang.r + verticalBob * 0.5;
				ang.p = ang.p - verticalBob * 0.4;
				ang.y = ang.y - lateralBob * 0.3;

				origin = origin + r * lateralBob * 0.8;

				self.MoneyViewmodel:SetPos( origin );
				self.MoneyViewmodel:SetRenderOrigin( origin );
				self.MoneyViewmodel:SetRenderAngles( ang );
				cam.IgnoreZ( true )
					self.MoneyViewmodel:DrawModel();
				cam.IgnoreZ( false );

			else

				if( !v.MoneyViewmodel or !v.MoneyViewmodel:IsValid() ) then
					v.MoneyViewmodel = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_BOTH );
					v.MoneyViewmodel:SetRenderBounds( Vector( -64, -64, -64 ), Vector( 64, 64, 64 ) );

					v.MoneyViewmodel.RenderOverride = function()

						if( v and v:IsValid() ) then
							
							if( v.HasMoney and v:Alive() ) then
								v.MoneyViewmodel:DrawModel();
							end

						end

					end;
				end

				local pos = v:EyePos();
				local ang = Angle();

				local attach = v:LookupAttachment( "anim_attachment_LH" );
				if( attach > 0 ) then

					local ap = v:GetAttachment( attach );

					pos = ap.Pos + Vector( 0, 0, -8 );
					ang:RotateAroundAxis( v:GetRight(), -90 );
					ang:RotateAroundAxis( v:GetUp(), -90 + ap.Ang.y );

				else

					local bone = -1;
					for i = 1, v:GetBoneCount() do

						if( v:GetBoneName( i - 1 ) == "ValveBiped.Bip01_L_Hand" ) then

							bone = i - 1;
							break;

						end

					end

					if( bone > -1 ) then

						local p, a = v:GetBonePosition( bone );
						pos = p + Vector( 0, 0, -10 );

						ang:RotateAroundAxis( v:GetRight(), -90 );
						ang:RotateAroundAxis( v:GetUp(), -90 + a.y );

					end

				end

				v.MoneyViewmodel:SetPos( pos );
				v.MoneyViewmodel:SetRenderOrigin( pos );
				v.MoneyViewmodel:SetRenderAngles( ang );
				v.MoneyViewmodel:DrawModel();

			end

		end

	end

	local wep = LocalPlayer():GetActiveWeapon();
	local fakeWep = ( wep and wep:IsValid() and wep:GetClass() == "weapon_coi_trickbag" );

	if( fakeWep ) then

		if( !self.FakeMoneyViewmodel or !self.FakeMoneyViewmodel:IsValid() ) then
			self.FakeMoneyViewmodel = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_VIEWMODEL );
			self.FakeMoneyViewmodel:SetRenderBounds( Vector( -256, -256, -256 ), Vector( 256, 256, 256 ) );
			self.FakeMoneyViewmodel.m_vecLastFacing = EyePos();

			self.FakeMoneyViewmodel.RenderOverride = function()

				local wep = LocalPlayer():GetActiveWeapon();
				if( wep and wep:IsValid() and wep:GetClass() == "weapon_coi_trickbag" ) then
					self.FakeMoneyViewmodel:DrawModel();
				end

			end;
		end

		local f = EyeAngles():Forward();
		local r = EyeAngles():Right();
		local u = EyeAngles():Up();

		local pos = EyePos() + f * 20 + r * 8 + u * -15;

		local ang = EyeAngles();
		ang:RotateAroundAxis( r, -110 );
		ang:RotateAroundAxis( f, -20 );

		if( !self.FakeMoneyViewmodel.m_vecLastFacing ) then
			self.FakeMoneyViewmodel.m_vecLastFacing = EyePos();
		end
		
		local vDifference = self.FakeMoneyViewmodel.m_vecLastFacing - f;
		
		local flSpeed = 7;
		
		local flDiff = vDifference:Length();
		if( flDiff > 1.5 ) then
			
			flSpeed = flSpeed * ( flDiff / 1.5 );
			
		end
		
		vDifference:Normalize();
		
		self.FakeMoneyViewmodel.m_vecLastFacing = self.FakeMoneyViewmodel.m_vecLastFacing + vDifference * flSpeed * FrameTime();
		self.FakeMoneyViewmodel.m_vecLastFacing:Normalize();
		local newPos = pos + ( vDifference * -1 ) * 5;

		-- CBaseHL2MPCombatWeapon::AddViewmodelBob
		local f = ang:Forward();
		local r = ang:Right();

		local verticalBob, lateralBob = self:CalcViewmodelBob();

		local origin = newPos + f * verticalBob * 0.1;
		origin.z = origin.z + verticalBob * 0.1;

		ang.r = ang.r + verticalBob * 0.5;
		ang.p = ang.p - verticalBob * 0.4;
		ang.y = ang.y - lateralBob * 0.3;

		origin = origin + r * lateralBob * 0.8;
		
		self.FakeMoneyViewmodel:SetPos( origin );
		self.FakeMoneyViewmodel:SetRenderOrigin( origin );
		self.FakeMoneyViewmodel:SetRenderAngles( ang );
		cam.IgnoreZ( true )
			self.FakeMoneyViewmodel:DrawModel();
		cam.IgnoreZ( false );

	end

end

-- void CBaseHL2MPCombatWeapon::AddViewmodelBob( CBaseViewModel *viewmodel, Vector &origin, QAngle &angles )
local bobtime = 0;
local lastbobtime = 0;
local HL2_BOB_CYCLE_MAX = 0.45;
local HL2_BOB_UP = 0.5;
function GM:CalcViewmodelBob()

	local cycle;
	local ply = LocalPlayer();

	local speed = ply:GetVelocity():Length2D();
	speed = math.min( speed, 320 );
	local bob_offset = speed / 320;

	bobtime = bobtime + ( CurTime() - lastbobtime ) * bob_offset;
	lastbobtime = CurTime();

	cycle = bobtime - math.floor( bobtime / HL2_BOB_CYCLE_MAX ) * HL2_BOB_CYCLE_MAX;
	cycle = cycle / HL2_BOB_CYCLE_MAX;

	if( cycle < HL2_BOB_UP ) then
		cycle = math.pi * cycle / HL2_BOB_UP;
	else
		cycle = math.pi + math.pi * ( cycle - HL2_BOB_UP ) / ( 1 - HL2_BOB_UP );
	end

	local verticalBob = speed * 0.005;
	verticalBob = verticalBob * 0.3 + verticalBob * 0.7 * math.sin( cycle );
	verticalBob = math.Clamp( verticalBob, -7, 4 );

	cycle = bobtime - math.floor( bobtime / HL2_BOB_CYCLE_MAX * 2 ) * HL2_BOB_CYCLE_MAX * 2;
	cycle = cycle / ( HL2_BOB_CYCLE_MAX * 2 );

	if( cycle < HL2_BOB_UP ) then
		cycle = math.pi * cycle / HL2_BOB_UP;
	else
		cycle = math.pi + math.pi * ( cycle - HL2_BOB_UP ) / ( 1 - HL2_BOB_UP );
	end

	local lateralBob = speed * 0.005;
	lateralBob = lateralBob * 0.3 + lateralBob * 0.7 * math.sin( cycle );
	lateralBob = math.Clamp( lateralBob, -7, 4 );
	
	return verticalBob, lateralBob;

end

function GM:PostDraw2DSkyBox()

	if( false ) then --= disabled until I can get sounds working
		if( !self.SkyboxHelicopter ) then
			self.SkyboxHelicopter = ClientsideModel( "models/Combine_Helicopter.mdl", RENDERGROUP_BOTH );
		end

		if( self:GetState() == STATE_POSTGAME or ( self:GetState() == STATE_GAME and self:TimeLeftInState() < 3 * 60 ) ) then

			render.OverrideDepthEnable( true, false );

			cam.Start3D();

				if( !self.NextHelicopter ) then
					self.NextHelicopter = 0;
				end
				if( CurTime() >= self.NextHelicopter ) then

					local timeSince = math.Clamp( CurTime() - self.NextHelicopter, 0, 12 ) / 12;

					if( timeSince >= 1 ) then
						self.NextHelicopter = CurTime() + math.random( 30, 60 );
					else

						local pos = Vector( -3000 + 10000 * timeSince, -540, 1000 );

						self.SkyboxHelicopter:SetAngles( Vector( 1, 0, 0 ):Angle() );
						
						self.SkyboxHelicopter:SetPos( pos );
						self.SkyboxHelicopter:FrameAdvance();
						self.SkyboxHelicopter:DrawModel();

					end

				end

			cam.End3D();

			render.OverrideDepthEnable( false, false );

		end
	end

end

matproxy.Add( {
	name = "PlayerColor",

	init = function( self, mat, values )
		-- Store the name of the variable we want to set
		self.ResultTo = values.resultvar
	end,

	bind = function( self, mat, ent )
		if ( !IsValid( ent ) ) then return end

		

		-- If entity is a ragdoll try to convert it into the player
		-- ( this applies to their corpses )
		if ( ent:IsRagdoll() ) then
			local owner = ent:GetRagdollOwner()
			if ( IsValid( owner ) ) then ent = owner end
		end

		-- If the target ent has a function called GetPlayerColor then use that
		-- The function SHOULD return a Vector with the chosen player's colour.
		if ( ent.GetPlayerColor ) then
			local col = ent:GetPlayerColor()
			if( ent:IsPlayer() and ent.IsCloaked and ent:IsCloaked() ) then
				col = LocalPlayer():GetPlayerColor();
			end
			if ( isvector( col ) ) then
				mat:SetVector( self.ResultTo, col )
			end
		else
			mat:SetVector( self.ResultTo, Vector( 62 / 255, 88 / 255, 106 / 255 ) )
		end
	end
} );

function GM:PreDrawPlayerHands( hands, vm, ply, wep )

	if( ply == LocalPlayer() and ply.HasMoney ) then
		
		for i = 1, vm:GetBoneCount() do

			local name = vm:GetBoneName( i - 1 );
			if( string.find( name, "ValveBiped.Bip01_L_" ) ) then
				
				local pos, ang = vm:GetBonePosition( i - 1 );

				local matrix = Matrix();
				matrix:Scale( Vector( 0.01, 0.01, 0.01 ) );

				vm:SetBoneMatrix( i - 1, matrix );

			end

		end

	end

end

function GM:PostDrawPlayerHands( hands, vm, ply, wep )
	
	if( ply == LocalPlayer() ) then
		
		for i = 1, vm:GetBoneCount() do

			local name = vm:GetBoneName( i - 1 );
			if( name == "ValveBiped.Bip01_L_UpperArm" ) then

				local matrix = Matrix();
				matrix:Scale( Vector( 1, 1, 1 ) );

				vm:SetBoneMatrix( i - 1, matrix );
				break;

			end

		end

	end

end