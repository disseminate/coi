AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:Use( ply )

	if( !ply.HasMoney ) then return end
	if( ply:Team() != self:GetTeam() ) then
		net.Start( "nMsgWrongTruck" );
		net.Send( ply );
		return;
	end

	local amt = math.random( 200, 500 );
	self:SetMoney( self:GetMoney() + amt );

	net.Start( "nMsgTruckDeposit" );
		net.WriteUInt( amt, 32 );
	net.Send( ply );

	self:EmitSound( Sound( "coi/kaching.wav" ), 120, math.random( 90, 110 ) );

	ply.HasMoney = false;
	net.Start( "nSetMoney" );
		net.WriteEntity( ply );
		net.WriteBool( false );
	net.Broadcast();

end

util.AddNetworkString( "nMsgWrongTruck" );
util.AddNetworkString( "nMsgTruckDeposit" );