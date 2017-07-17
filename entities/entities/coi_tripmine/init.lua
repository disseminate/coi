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
		trace.endpos = trace.start + self:GetUp() * 32768;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		self.TraceNormalHit = tr.Entity;

		if( SERVER ) then

			local dist = ( tr.HitPos - trace.start ):Length();
			self:SetCollisionBounds( Vector( -2, -2, 0 ), Vector( 2, 2, dist ) );

		end

		self.OnPos = self:GetPos();
		self.OnAng = self:GetAngles();

	end

	if( SERVER and self.StartExpl and CurTime() >= self.StartExpl and self:GetTripmineOn() ) then

		local trace = { };
		trace.start = self:GetPos() + self:GetUp();
		trace.endpos = trace.start + self:GetUp() * 32768;
		trace.filter = self;
		local tr = util.TraceLine( trace );

		if( self.TraceNormalHit and self.TraceNormalHit:IsValid() and tr.Entity != self.TraceNormalHit ) then

			self:Explode();

		end

	end

end

function ENT:StartTouch( e )

	if( self.StartExpl and CurTime() >= self.StartExpl and self:GetTripmineOn() ) then
		
		local expl = false;

		if( e and e:IsValid() ) then

			expl = true;

		end

		if( expl ) then

			self:Explode();

		end

	end

end

function ENT:Explode()

	if( !self.Exploded ) then
		
		self.Exploded = true;

		local ed = EffectData();
		ed:SetOrigin( self:GetPos() );
		util.Effect( "Explosion", ed, true, true );

		local ply = self:GetPlayer();
		if( !ply or !ply:IsValid() ) then
			ply = self;
		end

		util.BlastDamage( self, ply, self:GetPos(), 256, 300 );

		self:Remove();

	end

end

function ENT:OnTakeDamage( dmg )

	if( dmg:IsBulletDamage() ) then
		self:Explode();
	end

end