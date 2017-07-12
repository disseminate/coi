AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Think()

	if( self.TripmineOnTime and CurTime() >= self.TripmineOnTime ) then

		self.TripmineOnTime = nil;
		self:SetTripmineOn( true );
		self:EmitSound( Sound( "buttons/button16.wav" ) );
		self.StartExpl = CurTime() + 0.2; -- some delay for sound

		self.OnPos = self:GetPos();
		self.OnAng = self:GetAngles();

	end

	if( self.StartExpl and CurTime() >= self.StartExpl and self:GetTripmineOn() ) then

		local expl = false;

		for _, v in pairs( player.GetAll() ) do

			if( v:GetPos():Distance( self:GetPos() ) < 170 ) then

				if( !self:GetPlayer() or !self:GetPlayer():IsValid() or self:GetPlayer():Team() != v:Team() ) then

					expl = true;
					break;

				end

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