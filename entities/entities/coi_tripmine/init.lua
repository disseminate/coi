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
		trace.start = self:GetPos() + self:GetUp();
		trace.endpos = self:GetUp() * 32768;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		self.TraceNormalHit = tr.Entity;

		self.OnPos = self:GetPos();
		self.OnAng = self:GetAngles();

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

		if( self.OnPos:Distance( self:GetPos() ) >= 1 or math.AngleDifference( self.OnAng.y, self:GetAngles().y ) >= 1 ) then
			
			expl = true;

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

	local ply = self:GetPlayer();
	if( !ply or !ply:IsValid() ) then
		ply = self;
	end

	util.BlastDamage( self, ply, self:GetPos(), 256, 300 );

	self:Remove();

end

function ENT:OnTakeDamage( dmg )

	if( dmg:IsBulletDamage() ) then
		self:Explode();
	end

end