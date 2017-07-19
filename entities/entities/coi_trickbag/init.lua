AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Explode()

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

function ENT:Think()

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

function ENT:Use( ply )

	if( GAMEMODE:GetState() != STATE_GAME ) then return end

	self:Explode();

end

function ENT:StartTouch( ent )

	

end