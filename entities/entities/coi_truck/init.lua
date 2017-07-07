AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

function ENT:Use( ply )
	
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

		if( ply:Team() != self:GetTeam() ) then
			net.Start( "nMsgWrongTruck" );
			net.Send( ply );
			return;
		end

		local min, max = ply:GetBagMoney();

		local amt = math.random( min, max );
		team.AddScore( self:GetTeam(), amt );

		ply.Bags = ( ply.Bags or 0 ) + 1;

		net.Start( "nMsgTruckDeposit" );
			net.WriteUInt( amt, NET_MAX_BAG_MONEY );
		net.Send( ply );

		self:EmitSound( Sound( "coi/kaching.wav" ), 120, math.random( 90, 110 ) );

		ply.HasMoney = false;
		net.Start( "nSetHasMoney" );
			net.WriteEntity( ply );
			net.WriteBool( false );
		net.Broadcast();

	end

end

util.AddNetworkString( "nMsgWrongTruck" );
util.AddNetworkString( "nMsgTruckDeposit" );
util.AddNetworkString( "nSetSafe" );