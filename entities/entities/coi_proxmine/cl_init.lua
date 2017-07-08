include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Draw()

	self:DrawModel();

	if( self:GetTripmineOn() ) then

		render.SetMaterial( GAMEMODE:GetSkin().MAT_GLOW );
		render.DrawSprite( self:GetPos() + self:GetUp() * 2, 16, 16, Color( 255, 0, 0 ) );

	end

end