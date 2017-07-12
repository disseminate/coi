EXPORTS["voicedisguiser"] = { };

EXPORTS["voicedisguiser"].Name = "Voice Disguiser";
EXPORTS["voicedisguiser"].Desc = "When not carrying money, it looks like you're on everyone's team.";
EXPORTS["voicedisguiser"].Secondary = false;
EXPORTS["voicedisguiser"].Price = 14000;
EXPORTS["voicedisguiser"].Model = "models/Items/battery.mdl";
EXPORTS["voicedisguiser"].W = 3;
EXPORTS["voicedisguiser"].H = 3;
EXPORTS["voicedisguiser"].OnGive = function( ply )

	ply.Cloaked = true;

	net.Start( "nCloak" );
		net.WriteEntity( ply );
	net.Broadcast();

end

if( CLIENT ) then

	net.Receive( "nCloak", function( len )

		local ply = net.ReadEntity();
		ply.Cloaked = true;

	end );
	
else

	util.AddNetworkString( "nCloak" );

end