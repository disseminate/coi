AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Think()

	if( self.TripmineOnTime and CurTime() >= self.TripmineOnTime ) then

		self.TripmineOnTime = nil;
		self:SetTripmineOn( true );
		self:EmitSound( Sound( "buttons/button16.wav" ) );
		self.StartExpl = CurTime() + 0.2; -- some delay for sound

		local trace = { };
		trace.start = self:GetPos() + self:GetForward() * 8;
		trace.endpos = self:GetForward() * 32768;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		self.TraceNormalHit = tr.Entity;

	end

	if( self.StartExpl and CurTime() >= self.StartExpl and self:GetTripmineOn() ) then

		local trace = { };
		trace.start = self:GetPos() + self:GetUp();
		trace.endpos = self:GetUp() * 32768;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		local expl = false;

		if( self.TraceNormalHit and self.TraceNormalHit:IsValid() ) then
			
			if( tr.Entity != self.TraceNormalHit ) then

				expl = true;

			end

		else

			if( tr.Entity and tr.Entity:IsValid() ) then

				expl = true;

			end

		end

		if( expl ) then

			self:Explode();

		end

		self:NextThink( CurTime() );
		return true;

	end

end

function ENT:Explode()

	local ed = EffectData();
	ed:SetOrigin( self:GetPos() );
	util.Effect( "Explosion", ed );

	util.BlastDamage( self, self:GetPlayer(), self:GetPos(), 256, 200 );

	self:Remove();

end