AddCSLuaFile( "cl_init.lua" );
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

		end

	end

end

function ENT:PhysicsCollide( data, obj )

	if( data.Speed > 100 ) then
		self:EmitSound( Sound( "coi/coin.wav" ), 100, math.random( 80, 120 ) );
	end

end