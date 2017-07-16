AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Use( ply )

	ply:Loadout();
	
	if( GAMEMODE:InRushPeriod() ) then

		if( !ply.Safe ) then

			if( ( ply.LastUnsafe and CurTime() - ply.LastUnsafe >= 0.1 ) or !ply.LastUnsafe ) then
				
				ply.Safe = true;
				net.Start( "nSetSafe" );
					net.WriteEntity( ply );
					net.WriteBool( true );
				net.Broadcast();

			end

		end

	end

	if( ply.HasMoney ) then

		self:AttemptDeposit( ply );

	end

end

function ENT:AttemptDeposit( ply )

	if( ply:Team() != self:GetTeam() ) then
		net.Start( "nMsgWrongTruck" );
		net.Send( ply );
		return false;
	end

	local min, max = ply:GetBagMoney();

	local amt = math.random( min, max );
	team.AddScore( self:GetTeam(), amt );

	ply.Bags = ( ply.Bags or 0 ) + 1;

	net.Start( "nMsgTruckDeposit" );
		net.WriteUInt( amt, NET_MAX_BAG_MONEY );
	net.Send( ply );

	self:EmitSound( Sound( "coi/kaching.wav" ), 120, math.random( 90, 110 ) );

	if( ply.HasMoney ) then
		
		ply.HasMoney = false;
		net.Start( "nSetHasMoney" );
			net.WriteEntity( ply );
			net.WriteBool( false );
		net.Broadcast();
		
	end

	return true;

end

util.AddNetworkString( "nMsgWrongTruck" );
util.AddNetworkString( "nMsgTruckDeposit" );
util.AddNetworkString( "nSetSafe" );