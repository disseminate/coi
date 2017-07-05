local HUDElements = {
	"CHudAmmo",
	"CHudBattery",
	"CHudHealth",
	"CHudWeaponSelection"
};

function GM:HUDShouldDraw( name )

	if( table.HasValue( HUDElements, name ) ) then return false; end
	if( !LocalPlayer().Joined or self:GetState() == STATE_POSTGAME ) then
		if( name == "CHudCrosshair" ) then return false end
	end

	return self.BaseClass:HUDShouldDraw( name );

end

local HUDApproaches = { };
local HUDTimes = { };
function HUDApproach( val, targ, default, speed )

	if( !HUDApproaches[val] ) then
	
		HUDApproaches[val] = default;

	end

	HUDApproaches[val] = math.Approach( HUDApproaches[val], targ, math.abs( ( HUDApproaches[val] - targ ) / ( speed or 45 ) ) );
	return HUDApproaches[val];

end
function HUDEase( val, duration, start, endpos, easeIn, easeOut )

	if( !HUDApproaches[val] ) then
		HUDApproaches[val] = 0;
		HUDTimes[val] = CurTime();
	end

	local mul = ( CurTime() - HUDTimes[val] ) / duration;

	HUDApproaches[val] = math.EaseInOut( math.Clamp( mul, 0, 1 ), easeIn or 1, easeOut or 1 );
	return HUDApproaches[val] * ( endpos - start ) + start;

end

function HUDClear( val )

	HUDApproaches[val] = nil;
	HUDTimes[val] = nil;

end

function GM:HUDPaint()

	if( !LocalPlayer().Joined ) then
		self:HUDPaintJoining();
		return;
	end

	if( self:GetState() != STATE_PREGAME ) then

		self:HUDPaintTimer();
		self:HUDPaintHealth();
		self:HUDPaintMoney();
		self:HUDPaintDirectionArrow();
		self:HUDPaintGameOver();

	end

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

function GM:HUDPaintMoney()

	for _, v in pairs( ents.FindByClass( "coi_money" ) ) do

		if( v:GetDropped() ) then

			local p = v:GetPos();

			local dist = LocalPlayer():GetPos():Distance( p );

			if( dist < 1000 ) then

				local amul = 1;
				if( dist >= 700 ) then

					amul = 1 - ( ( dist - 700 ) / 300 );

				end

				local trace = { };
				trace.start = EyePos();
				trace.endpos = p;
				trace.filter = { LocalPlayer() };
				local tr = util.TraceLine( trace );

				if( tr.Entity and tr.Entity:IsValid() and tr.Entity == v ) then

					surface.SetAlphaMultiplier( amul );
					
					local pp = p:ToScreen();
					local rad = 50;

					local p = math.Clamp( ( v:GetDieTime() - CurTime() ) / 15, 0, 1 );
					
					surface.DrawProgressCircle( pp.x, pp.y, p, rad );

					local t = "" .. math.abs( math.ceil( v:GetDieTime() - CurTime() ) );

					surface.SetFont( "COI Title 48" );
					surface.SetTextColor( self:GetSkin().COLOR_WHITE );
					local w, h = surface.GetTextSize( t );
					surface.SetTextPos( pp.x - w / 2, pp.y - h / 2 );
					surface.DrawText( t );

					local t = "Money";

					surface.SetFont( "COI Title 24" );
					surface.SetTextColor( self:GetSkin().COLOR_WHITE );
					local w, h = surface.GetTextSize( t );
					surface.SetTextPos( pp.x - w / 2, pp.y + ( rad * 1.3 ) );
					surface.DrawText( t );

					surface.SetAlphaMultiplier( 1 );

				end

			end

		end

	end

end

function GM:HUDResetGameOver()

	for i = 1, 20 do
		HUDClear( "gameover_" .. i );
	end

	self.TestTime = CurTime();

end

function GM:HUDPaintDirectionArrow()

	local a;
	local pos = LocalPlayer():GetPos();

	local teams = self.Teams;
	if( !teams ) then return end
	if( !teams[LocalPlayer():Team()] ) then return end
	if( !teams[LocalPlayer():Team()].Truck or !teams[LocalPlayer():Team()].Truck:IsValid() ) then return end

	local truck = teams[LocalPlayer():Team()].Truck;

	local tpos = truck:GetPos();

	if( math.abs( tpos.z - pos.z ) < 100 and ( LocalPlayer().HasMoney or self:InRushPeriod() ) and !LocalPlayer().Safe ) then

		a = HUDApproach( "arrow", 1, 0 );

	else

		a = HUDApproach( "arrow", 0, 0 );

	end

	if( a > 0 ) then

		local aim = LocalPlayer():GetAimVector():Angle();
		local d = math.AngleDifference( aim.y, ( tpos - pos ):Angle().y );

		self:GetSkin().ICON_ARROW:SetFloat( "$alpha", a );

		surface.SetDrawColor( self:GetSkin().COLOR_WHITE );
		surface.SetMaterial( self:GetSkin().ICON_ARROW );
		surface.DrawTexturedRectRotated( ScrW() / 2, ScrH() - 40 - 100, 64, 64, 90 - d );

		surface.SetAlphaMultiplier( a );

			surface.SetFont( "COI Title 30" );
			local t;

			if( LocalPlayer().HasMoney ) then
				surface.SetTextColor( self:GetSkin().COLOR_WHITE );
				t = "Put the money in the truck!";
			else
				t = "Get to your truck before you're arrested!";
				surface.SetTextColor( self:GetSkin().COLOR_WARNING );
			end

			local w, h = surface.GetTextSize( t );
			surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() - 40 - h );
			surface.DrawText( t );

		surface.SetAlphaMultiplier( 1 );

	end

end

function GM:HUDPaintGameOver()

	if( self:GetState() == STATE_POSTGAME ) then

		local dt = STATE_TIMES[STATE_POSTGAME] - self:TimeLeftInState();

		surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), math.Clamp( dt, 0, 4 ) / 4 );

	elseif( self:GetState() == STATE_PREGAME ) then

		surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), 1 );

	end

	if( self:GetState() != STATE_POSTGAME ) then return end

	if( dt < 5 ) then

		surface.SetFont( "COI Title 64" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = "Heist";
		local w, h = surface.GetTextSize( t );
		if( dt < 4 ) then
			local ym = HUDEase( "gameover_1", 1, -ScrH() * 0.2, ScrH() / 2 - 100, 0, 1 );
			surface.SetTextPos( ScrW() / 2 - w / 2, ym );
		else
			local ym = HUDEase( "gameover_3", 1, ScrH() / 2 - 100, ScrH() * 1.2, 1, 0 );
			surface.SetTextPos( ScrW() / 2 - w / 2, ym );
		end
		surface.DrawText( t );

		if( dt > 0.7 ) then

			surface.SetFont( "COI Title 128" );
			local t = "Successful";

			if( LocalPlayer().Safe ) then
				surface.SetTextColor( self:GetSkin().COLOR_SUCCESS );
			else
				surface.SetTextColor( self:GetSkin().COLOR_FAIL );
				t = "Failed";
			end

			local w, h = surface.GetTextSize( t );
			if( dt < 4.3 ) then
				local ym = HUDEase( "gameover_2", 1, -ScrH() * 0.2, ScrH() / 2, 0, 1 );
				surface.SetTextPos( ScrW() / 2 - w / 2, ym );
			else
				local ym = HUDEase( "gameover_4", 0.7, ScrH() / 2, ScrH() * 1.2, 1, 0 );
				surface.SetTextPos( ScrW() / 2 - w / 2, ym );
			end
			surface.DrawText( t );

		end

	elseif( dt < 10 ) then

		surface.SetFont( "COI Title 64" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = "Winning Crew";
		local w, h = surface.GetTextSize( t );
		if( dt < 9 ) then
			local xm = HUDEase( "gameover_5", 1, ScrW(), ScrW() / 2 - w / 2, 0, 1 );
			surface.SetTextPos( xm, ScrH() / 2 - h / 2 - 100 );
		else
			local xm = HUDEase( "gameover_7", 1, ScrW() / 2 - w / 2, -w, 1, 0 );
			surface.SetTextPos( xm, ScrH() / 2 - h / 2 - 100 );
		end
		surface.DrawText( t );

		if( dt > 5.7 ) then

			surface.SetFont( "COI Title 128" );
			surface.SetTextColor( self:GetSkin().COLOR_FAIL );
			local t = "The Good Crew";
			local w, h = surface.GetTextSize( t );
			if( dt < 9.3 ) then
				local xm = HUDEase( "gameover_6", 1, ScrW(), ScrW() / 2 - w / 2, 0, 1 );
				surface.SetTextPos( xm, ScrH() / 2 - h / 2 );
			else
				local xm = HUDEase( "gameover_8", 0.7, ScrW() / 2 - w / 2, -w, 1, 0 );
				surface.SetTextPos( xm, ScrH() / 2 - h / 2 );
			end
			surface.DrawText( t );

		end

	end

end