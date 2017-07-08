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

		local expl = false;

		for _, v in pairs( player.GetAll() ) do

			if( v:GetPos():Distance( self:GetPos() ) < 170 ) then

				expl = true;
				break;

			end

		end

		if( expl ) then

			self:Explode();

		end

		self:NextThink( CurTime() );
		return true;

	end

end