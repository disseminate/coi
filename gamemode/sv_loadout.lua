local function nSetPrimaryLoadout( len, ply )

	if( GAMEMODE:GetState() != STATE_PREGAME ) then return end

	local item = net.ReadUInt( 16 );

	if( !ply.Inventory[item] ) then return end
	local i = ply.Inventory[item];
	if( GAMEMODE.Items[i.ItemClass].Secondary ) then return end

	ply.PrimaryLoadout = item;

end
net.Receive( "nSetPrimaryLoadout", nSetPrimaryLoadout );
util.AddNetworkString( "nSetPrimaryLoadout" );

local function nSetSecondaryLoadout( len, ply )

	if( GAMEMODE:GetState() != STATE_PREGAME ) then return end
	
	local item = net.ReadUInt( 16 );

	if( !ply.Inventory[item] ) then return end
	local i = ply.Inventory[item];
	if( !GAMEMODE.Items[i.ItemClass].Secondary ) then return end

	ply.SecondaryLoadout = item;

end
net.Receive( "nSetSecondaryLoadout", nSetSecondaryLoadout );
util.AddNetworkString( "nSetSecondaryLoadout" );

local function nClearPrimaryLoadout( len, ply )

	if( GAMEMODE:GetState() != STATE_PREGAME ) then return end

	ply.PrimaryLoadout = nil;

end
net.Receive( "nClearPrimaryLoadout", nClearPrimaryLoadout );
util.AddNetworkString( "nClearPrimaryLoadout" );

local function nClearSecondaryLoadout( len, ply )

	if( GAMEMODE:GetState() != STATE_PREGAME ) then return end

	ply.SecondaryLoadout = nil;

end
net.Receive( "nClearSecondaryLoadout", nClearSecondaryLoadout );
util.AddNetworkString( "nClearSecondaryLoadout" );