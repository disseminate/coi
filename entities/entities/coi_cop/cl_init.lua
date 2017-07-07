include( "shared.lua" );

function ENT:Draw()

	self:DrawModel();

	if( !self.Gun ) then

		self.Gun = ClientsideModel( "models/weapons/w_pistol.mdl", RENDERGROUP_BOTH );
		self.Gun:SetParent( self );
		self.Gun:AddEffects( EF_BONEMERGE );

	else

		self.Gun:SetPos( self:GetPos() );

	end

end

function ENT:OnRemove()

	if( self.Gun ) then

		self.Gun:Remove();

	end

end