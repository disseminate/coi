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

		render.SetMaterial( GAMEMODE:GetSkin().MAT_REDLASER );
		render.DrawBeam( tr.StartPos, tr.HitPos, 4, 0, ( tr.HitPos - tr.StartPos ):Length() / 128, Color( 255, 255, 255 ) );

	end

end