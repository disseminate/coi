function GM:PreDrawOpaqueRenderables( depth, sky )
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v.HasMoney ) then

			if( v == LocalPlayer() ) then
				
				if( !self.MoneyViewmodel or !self.MoneyViewmodel:IsValid() ) then
					self.MoneyViewmodel = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_VIEWMODEL );
					self.MoneyViewmodel:SetRenderBounds( Vector( -256, -256, -256 ), Vector( 256, 256, 256 ) );
					self.MoneyViewmodel.m_vecLastFacing = EyePos();

					self.MoneyViewmodel.RenderOverride = function()

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

				self.MoneyViewmodel:SetPos( newPos );
				self.MoneyViewmodel:SetRenderOrigin( newPos );
				self.MoneyViewmodel:SetRenderAngles( ang );
				cam.IgnoreZ( true )
					self.MoneyViewmodel:DrawModel();
				cam.IgnoreZ( false );

			else

				if( !v.MoneyViewmodel or !v.MoneyViewmodel:IsValid() ) then
					v.MoneyViewmodel = ClientsideModel( "models/props_junk/garbage_bag001a.mdl", RENDERGROUP_BOTH );
					v.MoneyViewmodel:SetRenderBounds( Vector( -256, -256, -256 ), Vector( 256, 256, 256 ) );

					v.MoneyViewmodel.RenderOverride = function()

						if( v and v:IsValid() ) then
							
							if( v.HasMoney ) then
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
			if( ent:IsPlayer() and ent:IsCloaked() ) then
				col = LocalPlayer():GetPlayerColor();
			end
			if ( isvector( col ) ) then
				mat:SetVector( self.ResultTo, col )
			end
		else
			mat:SetVector( self.ResultTo, Vector( 62 / 255, 88 / 255, 106 / 255 ) )
		end
	end
} )