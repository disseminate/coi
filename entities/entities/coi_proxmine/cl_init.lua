include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Draw()

	self:DrawModel();

	if( self:GetTripmineOn() ) then

		local col = GAMEMODE:GetSkin().COLOR_WHITE;

		if( self:GetPlayer() and self:GetPlayer():IsValid() ) then
			col = team.GetColor( self:GetPlayer():Team() );
		end

		render.SetMaterial( GAMEMODE:GetSkin().MAT_GLOW );
		render.DrawSprite( self:GetPos() + self:GetUp() * 2, 16, 16, col );

	end

end