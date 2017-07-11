include( "shared.lua" );

function ENT:Draw()

	if( self:Alive() ) then
		
		self:DrawModel();

	end

	if( !self.Gun ) then

		self.Gun = ClientsideModel( "models/weapons/w_pistol.mdl", RENDERGROUP_BOTH );
		self.Gun:SetParent( self );
		self.Gun:AddEffects( EF_BONEMERGE );
		function self.Gun:RenderOverride()

			if( !self:GetParent() or !self:GetParent():IsValid() or !self:GetParent():Alive() ) then return end
			self:DrawModel();

		end

	elseif( self.Gun and self.Gun:IsValid() ) then

		self.Gun:SetPos( self:GetPos() );
		self.Gun:DrawModel();

	end

end

function ENT:OnRemove()

	if( self.Gun ) then

		self.Gun:Remove();

	end

end