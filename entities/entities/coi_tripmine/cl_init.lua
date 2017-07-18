include( "shared.lua" );

ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Draw()

	self:DrawModel();

	if( self:GetTripmineOn() ) then

		local trace = { };
		trace.start = self:GetPos();
		trace.endpos = self:GetUp() * 32768;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		local col = GAMEMODE:GetSkin().COLOR_WHITE;

		if( self:GetPlayer() and self:GetPlayer():IsValid() ) then
			col = team.GetColor( self:GetPlayer():Team() );
		end

		render.SetMaterial( GAMEMODE:GetSkin().MAT_LASER );
		render.DrawBeam( tr.StartPos, tr.HitPos, 4, 0, ( tr.HitPos - tr.StartPos ):Length() / 128, col );

	end

end