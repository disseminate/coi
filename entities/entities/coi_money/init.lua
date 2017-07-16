AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Use( ply )

	if( GAMEMODE:GetState() != STATE_GAME ) then return end

	GAMEMODE:PlayerTakeMoney( ply, self );
	self:EmitSound( Sound( "coi/coin.wav" ), 100, math.random( 80, 120 ) );

	if( self:GetDropped() ) then
		self:Remove();
	end

end

function ENT:Think()

	if( self:GetDropped() ) then

		if( CurTime() >= self:GetDieTime() ) then

			self:Remove();

		else

			local trace = { };
			trace.start = self:GetPos();
			trace.endpos = self:GetPos();
			trace.mins = Vector( -12, -12, -12 );
			trace.maxs = Vector( 12, 12, 12 );
			trace.filter = self;
			local tr = util.TraceLine( trace );

			if( tr.Entity and tr.Entity:IsValid() and tr.Entity:GetClass() == "coi_cop" ) then

				local dmg = DamageInfo();
				dmg:SetDamage( 100 );
				dmg:SetDamageForce( self:GetVelocity() * 30 );
				dmg:SetDamagePosition( tr.HitPos );
				dmg:SetDamageType( DMG_CLUB );
				dmg:SetAttacker( self.Owner );
				dmg:SetInflictor( self );
				tr.Entity:TakeDamageInfo( dmg );

				self:EmitSound( Sound( "coi/kaching2.wav" ) );

			end

			self:NextThink( CurTime() );
			return true;

		end

	end

end

function ENT:PhysicsCollide( data, obj )

	if( data.Speed > 100 ) then
		self:EmitSound( Sound( "coi/coin.wav" ), 100, math.random( 80, 120 ) );
	end

	if( self:GetDropped() ) then

		if( data.HitEntity and data.HitEntity:IsValid() and data.HitEntity:GetClass() == "coi_truck" ) then

			if( self.Owner and self.Owner:IsValid() ) then
				
				if( data.HitEntity:AttemptDeposit( self.Owner ) ) then

					self:Remove();

				end

			end

		end

	end

end