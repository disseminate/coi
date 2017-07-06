local function nSetMoney( len )

	local amt = net.ReadUInt( 32 );

	GAMEMODE.Money = amt;

end
net.Receive( "nSetMoney", nSetMoney );
