local HUDElements = {
	"CHudAmmo",
	"CHudBattery",
	"CHudHealth",
	"CHudWeaponSelection"
};

function GM:HUDShouldDraw( name )

	if( table.HasValue( HUDElements, name ) ) then return false; end
	if( !LocalPlayer().Joined ) then
		if( name == "CHudCrosshair" ) then return false end
	end

	return self.BaseClass:HUDShouldDraw( name );

end

local HUDApproaches = { };
function HUDApproach( val, targ, default )

	if( !HUDApproaches[val] ) then
	
		HUDApproaches[val] = default;

	end

	HUDApproaches[val] = math.Approach( HUDApproaches[val], targ, math.abs( ( HUDApproaches[val] - targ ) / 45 ) ); -- 45 is a "speed constant"
	return HUDApproaches[val];

end

function GM:HUDPaint()

	if( !LocalPlayer().Joined ) then
		self:HUDPaintJoining();
		return;
	end

	self:HUDPaintTimer();
	self:HUDPaintHealth();

end

function GM:HUDPaintJoining()

	surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), 1 );

	surface.SetFont( "COI Title 128" );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	local t = "Conflict of Interest";
	local w, h = surface.GetTextSize( t );
	surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 );
	surface.DrawText( t );

	surface.SetFont( "COI Title 30" );
	local t = "Press Space";
	local w2, h2 = surface.GetTextSize( t );
	surface.SetTextPos( ScrW() / 2 - w2 / 2, ScrH() / 2 + h / 2 + 10 );
	surface.DrawText( t );

end

function GM:HUDPaintTimer()

	if( #player.GetJoined() == 0 ) then return end
	--if( self:GetState() == STATE_PREGAME ) then return end -- vgui will do this

	local state = self:GetState();
	local timeLeft = self:TimeLeftInState();
	local text;
	local text2 = " / " .. string.ToMinutesSeconds( STATE_TIMES[state] );
	local col = self:GetSkin().COLOR_WHITE;
	if( state == STATE_PREGAME ) then
		text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
		col = self:GetSkin().COLOR_GRAY;
	elseif( state == STATE_GAME ) then
 		text = string.ToMinutesSeconds( STATE_TIMES[state] - timeLeft );
	else
		text = string.ToMinutesSeconds( math.floor( timeLeft ) + 1 );
		col = self:GetSkin().COLOR_GRAY;
	end

	surface.SetFont( "COI Title 48" );

	local w, h = surface.GetTextSize( text );

	surface.SetTextColor( col );
	surface.SetTextPos( ScrW() / 2 - w / 2, 40 );
	surface.DrawText( text );

	surface.SetFont( "COI Title 24" );

	local w2, h2 = surface.GetTextSize( text2 );

	surface.SetTextColor( self:GetSkin().COLOR_GRAY );
	surface.SetTextPos( ScrW() / 2 + w / 2 + 4, 40 );
	surface.DrawText( text2 );

end

function GM:HUDPaintHealth()

	local bw = 400;
	local bh = 24;
	local pad = 2;

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
	surface.DrawRect( 40, ScrH() - 40 - bh, bw, bh );

	local hp = HUDApproach( "health", LocalPlayer():Health(), LocalPlayer():GetMaxHealth() );

	if( hp > 0 ) then
		
		surface.SetDrawColor( self:GetSkin().COLOR_HEALTH );
		surface.DrawRect( 40 + pad, ScrH() - 40 - bh + pad, ( bw - pad * 2 ) * ( hp / LocalPlayer():GetMaxHealth() ), bh - pad * 2 );

	end

	local hp = LocalPlayer():Health();

	surface.SetFont( "COI 20" );
	local w, h = surface.GetTextSize( hp );
	surface.SetTextPos( 40 + bw / 2 - w / 2, ScrH() - 40 - bh + bh / 2 - h / 2 );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.DrawText( hp );

end