local HUDElements = {
	"CHudAmmo",
	"CHudSecondaryAmmo",
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

	if( self:GetState() == STATE_GAME ) then

		self:HUDPaintMoney();
		self:HUDPaintPlayers();
		self:HUDPaintCops();
		self:HUDPaintTimer();
		self:HUDPaintHealth();
		self:HUDPaintWeapon();
		self:HUDPaintDirectionArrow();
		self:HUDPaintGetToTruck();

		self:HUDPaintUnconsciousness();

	end

	self:HUDPaintGameOver();

	self:HUDPaintBlackScreen();

end

function GM:HUDPaintJoining()

	surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), 1 );

	surface.SetFont( "COI Title 128" );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	local t = "Conflict of Interest";
	local w, h = surface.GetTextSize( t );
	local x = ScrW() / 2 - w / 2;
	local y = ScrH() / 2 - h / 2;
	surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
	surface.DrawRect( x - 20, y - 20, w + 40, h + 40 );
	surface.SetTextPos( x, y );
	surface.DrawText( t );

	surface.SetFont( "COI Title 30" );
	local t = I18( "press_space" );

	local w2, h2 = surface.GetTextSize( t );
	local x2 = ScrW() / 2 - w2 / 2;
	local y2 = y + h + 60;

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
	surface.DrawRect( x2 - 10, y2 - 10, w2 + 20, h2 + 20 );
	surface.SetTextPos( x2, y2 );
	surface.DrawText( t );

end

function GM:HUDPaintTimer()

	if( #player.GetJoined() == 0 ) then return end

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
	
	surface.SetFont( "COI Title 24" );

	local w2, h2 = surface.GetTextSize( text2 );

	local totalW = w + w2 + 4;
	local padding = 6;
	surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
	surface.DrawRect( ScrW() / 2 - w / 2 - padding, 40, totalW + padding * 2, 48 + padding * 2 );

	surface.SetFont( "COI Title 48" );

	surface.SetTextPos( ScrW() / 2 - w / 2, 40 + padding );
	surface.DrawText( text );

	surface.SetFont( "COI Title 24" );

	surface.SetTextColor( self:GetSkin().COLOR_GRAY );
	surface.SetTextPos( ScrW() / 2 + w / 2 + 4, 40 + padding );
	surface.DrawText( text2 );

end

function GM:HUDPaintHealth()

	local bw = ScrW() / 4;
	local bh = 24;
	local pad = 2;

	surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
	surface.DrawRect( 40, ScrH() - 40 - bh, bw, bh );

	local hp = HUDApproach( "health", math.max( LocalPlayer():Health(), 0 ), LocalPlayer():GetMaxHealth() );

	if( hp > 0 ) then
		
		surface.SetDrawColor( self:GetSkin().COLOR_HEALTH );
		surface.DrawRect( 40 + pad, ScrH() - 40 - bh + pad, ( bw - pad * 2 ) * ( hp / LocalPlayer():GetMaxHealth() ), bh - pad * 2 );

	end

	local hp = math.max( LocalPlayer():Health(), 0 );

	surface.SetFont( "COI 20" );
	local w, h = surface.GetTextSize( hp );
	surface.SetTextPos( 40 + bw / 2 - w / 2, ScrH() - 40 - bh + bh / 2 - h / 2 );
	surface.SetTextColor( self:GetSkin().COLOR_WHITE );
	surface.DrawText( hp );

end

function GM:HUDPaintWeapon()

	local wep = LocalPlayer():GetActiveWeapon();

	if( !wep or !wep:IsValid() or wep == NULL ) then return end

	local clip, ammo;

	if( wep.Primary and wep.Primary.Firearm ) then
		clip = wep:Clip1();
	end

	if( wep.Primary and wep.Primary.Ammo and !wep.Primary.InfiniteAmmo ) then
		ammo = LocalPlayer():GetAmmoCount( wep.Primary.Ammo );
	end

	local nw = #LocalPlayer():GetWeapons();
	local padding = 6;
	local y = 40;

	for k, v in pairs( LocalPlayer():GetWeapons() ) do

		surface.SetFont( "COI Title 30" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = v:GetPrintName();
		local w, h = surface.GetTextSize( t );

		local bw;
		if( v == LocalPlayer():GetActiveWeapon() ) then
			bw = HUDApproach( "weapon" .. k, math.max( 200, w ), w );
			surface.SetDrawColor( self:GetSkin().COLOR_GLASS );
		else
			bw = HUDApproach( "weapon" .. k, w, w );
			surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
		end

		surface.DrawRect( ScrW() - 40 - bw - padding * 2, y, bw + padding * 2, h + padding * 2 );

		surface.SetTextPos( ScrW() - 40 - w - padding, y + padding );
		surface.DrawText( t );

		y = y + h + padding * 2 + 10;

	end

	if( clip and ammo ) then

		surface.SetFont( "COI Title 30" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = "" .. ammo;
		local w, h = surface.GetTextSize( t );

		surface.SetFont( "COI Title 64" );
		local t2 = "" .. clip;
		local w2, h2 = surface.GetTextSize( t2 );

		local totalW = w + w2 + 10;

		local padding = 6;

		surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
		surface.DrawRect( ScrW() - 40 - totalW - padding * 2, ScrH() - 40 - 64 - padding * 2, totalW + padding * 2, 64 + padding * 2 );

		local x = ScrW() - 40 - w - padding;
		surface.SetFont( "COI Title 30" );
		surface.SetTextPos( x, ScrH() - 40 - 64 - padding );
		surface.DrawText( t );
		
		surface.SetFont( "COI Title 64" );

		x = x - w2 - 10;
		surface.SetTextPos( x, ScrH() - 40 - h2 - padding );
		surface.DrawText( t2 );

	elseif( clip ) then

		surface.SetFont( "COI Title 64" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = "" .. clip;
		local w, h = surface.GetTextSize( t );

		local padding = 6;

		surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
		surface.DrawRect( ScrW() - 40 - w - padding * 2, ScrH() - 40 - 64 - padding * 2, w + padding * 2, 64 + padding * 2 );

		surface.SetTextPos( ScrW() - 40 - w - padding, ScrH() - 40 - h - padding );
		surface.DrawText( t );

	end

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
					if( pp.visible ) then
						
						local rad = 50;

						local perc = math.Clamp( ( v:GetDieTime() - CurTime() ) / 15, 0, 1 );
						
						surface.DrawProgressCircle( pp.x, pp.y, perc, rad );

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

					end

					surface.SetAlphaMultiplier( 1 );

				end

			end

		end

	end

end

function GM:HUDPaintPlayers()

	for _, v in pairs( player.GetJoined() ) do

		if( v != LocalPlayer() ) then

			local p = v:EyePos();

			local dist = LocalPlayer():EyePos():Distance( p );

			if( dist < 1000 ) then

				local amul = 1;
				if( dist >= 700 ) then

					amul = 1 - ( ( dist - 700 ) / 300 );

				end

				local trace = { };
				trace.start = EyePos();
				trace.endpos = p + Vector( 0, 0, 32 );
				trace.filter = { LocalPlayer(), v };
				local tr = util.TraceLine( trace );

				if( tr.Fraction == 1 ) then

					surface.SetAlphaMultiplier( amul );
					
					local eye = v:EyePos() + Vector( 0, 0, 16 );
					local pp = eye:ToScreen();
					pp.y = pp.y - 8;

					local y = pp.y;
					
					local t = v:Nick();
					surface.SetFont( "COI 20" );
					surface.SetTextColor( team.GetColor( v:Team() ) );
					if( v:IsCloaked() ) then
						surface.SetTextColor( team.GetColor( LocalPlayer():Team() ) );
					end
					local w, h = surface.GetTextSize( t );
					surface.SetTextPos( pp.x - w / 2, y - h / 2 );
					surface.DrawText( t );

					y = y + h;

					surface.SetFont( "COI 18" );
					surface.SetTextColor( self:GetSkin().COLOR_WHITE );
					local t = v:Health() .. "%";
					local w, h = surface.GetTextSize( t );
					surface.SetTextPos( pp.x - w / 2, y );
					surface.DrawText( t );

					surface.SetAlphaMultiplier( 1 );

				end

			end

		end

	end

end

function GM:HUDPaintCops()

	for _, v in pairs( ents.FindByClass( "coi_cop" ) ) do

		if( v:Alive() ) then
			
			local p = v:GetPos() + Vector( 0, 0, 64 );

			local dist = LocalPlayer():EyePos():Distance( p );

			if( dist < 1000 ) then

				local amul = 1;
				if( dist >= 700 ) then

					amul = 1 - ( ( dist - 700 ) / 300 );

				end

				local trace = { };
				trace.start = EyePos();
				trace.endpos = p + Vector( 0, 0, 32 );
				trace.filter = { LocalPlayer(), v };
				local tr = util.TraceLine( trace );

				if( tr.Fraction == 1 ) then

					surface.SetAlphaMultiplier( amul );
					
					local eye = v:GetPos() + Vector( 0, 0, 64 + 16 );
					local pp = eye:ToScreen();
					pp.y = pp.y - 8;
					
					local t = I18( "cop" );
					surface.SetFont( "COI 20" );
					surface.SetTextColor( Color( 255, 255, 255 ) );
					local w, h = surface.GetTextSize( t );
					surface.SetTextPos( pp.x - w / 2, pp.y - h / 2 );
					surface.DrawText( t );

					surface.SetAlphaMultiplier( 1 );

				end

			end

		end

	end

end

function surface.PaintDirectionArrow( x, y, tpos, a )

	local pos = LocalPlayer():GetPos();
	local aim = LocalPlayer():GetAimVector():Angle();
	local d = math.AngleDifference( aim.y, ( tpos - pos ):Angle().y );

	GAMEMODE:GetSkin().ICON_ARROW:SetFloat( "$alpha", a );

	surface.SetDrawColor( GAMEMODE:GetSkin().COLOR_WHITE );
	surface.SetMaterial( GAMEMODE:GetSkin().ICON_ARROW );
	surface.DrawTexturedRectRotated( ScrW() / 2, ScrH() - 40 - 100, 64, 64, 90 - d );

end

function GM:HUDPaintGetToTruck()

	if( self:GetSetting( "warning", 1 ) == 0 ) then return end

	local a;

	if( self:InRushPeriod() and !LocalPlayer().Safe ) then

		a = HUDApproach( "tarrow", 1, 0 );

	else

		a = HUDApproach( "tarrow", 0, 0 );

	end

	if( a > 0 ) then

		surface.SetAlphaMultiplier( a );

			surface.SetFont( "COI Title 30" );
			surface.SetTextColor( self:GetSkin().COLOR_WARNING );
			local t = I18( "get_to_truck" );

			local w, h = surface.GetTextSize( t );
			local padding = 6;
			local x = ScrW() / 2 - w / 2;
			local y = ScrH() * ( 1 / 4 );

			surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
			surface.DrawRect( x - padding, y - padding * 2, w + padding * 2, h + padding * 2 );

			surface.SetTextPos( x, y - padding );
			surface.DrawText( t );

			y = y + h + 20;

			local pos = LocalPlayer():GetPos();
			local a2;

			local truck = LocalPlayer():GetTruck();

			if( truck and truck:IsValid() ) then

				local tpos = truck:GetPos();

				if( math.abs( tpos.z - pos.z ) < 100 and self:InRushPeriod() and !LocalPlayer().Safe ) then

					a2 = HUDApproach( "tarrow2", 1, 0 );

				else

					a2 = HUDApproach( "tarrow2", 0, 0 );

				end

				if( a2 > 0 ) then

					surface.SetAlphaMultiplier( a2 );

						local t = I18( "get_to_truck2" );

						surface.SetTextColor( self:GetSkin().COLOR_WARNING );

						surface.SetFont( "COI 18" );
						local w, h = surface.GetTextSize( t );
						local padding = 4;
						local x = ScrW() / 2 - w / 2;

						surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
						surface.DrawRect( x - padding, y - padding * 2, w + padding * 2, h + padding * 2 );

						surface.SetTextPos( x, y - padding );
						surface.DrawText( t );

				end

			end

		surface.SetAlphaMultiplier( 1 );

	end

end

function GM:HUDPaintDirectionArrow()

	local a;
	local pos = LocalPlayer():GetPos();

	local truck = LocalPlayer():GetTruck();

	if( truck and truck:IsValid() ) then

		local tpos = truck:GetPos();

		if( math.abs( tpos.z - pos.z ) < 100 and LocalPlayer().HasMoney ) then

			a = HUDApproach( "arrow", 1, 0 );

		else

			a = HUDApproach( "arrow", 0, 0 );

		end

		if( a > 0 ) then

			surface.PaintDirectionArrow( ScrW() / 2, ScrH() - 40 - 100, tpos, a );

			surface.SetAlphaMultiplier( a );

				surface.SetFont( "COI Title 30" );
				surface.SetTextColor( self:GetSkin().COLOR_WHITE );
				local t = I18( "money_to_truck" );

				local w, h = surface.GetTextSize( t );
				local padding = 6;

				surface.SetDrawColor( self:GetSkin().COLOR_GLASS_LIGHT );
				surface.DrawRect( ScrW() / 2 - w / 2 - padding, ScrH() - 40 - h - padding * 2, w + padding * 2, h + padding * 2 );

				surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() - 40 - h - padding );
				surface.DrawText( t );

			surface.SetAlphaMultiplier( 1 );

		end

	end

end

function GM:HUDPaintUnconsciousness()

	if( !LocalPlayer().Unconscious and LocalPlayer().Consciousness < 100 ) then

		surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), 1 - ( LocalPlayer().Consciousness / 100 ) );

	end

	if( LocalPlayer().Unconscious ) then

		local d = ( CurTime() - LocalPlayer().UnconsciousTime ) / 5;

		surface.DrawProgressCircle( ScrW() / 2, ScrH() / 2, d, 64 );

	end

end

function GM:HUDResetGameOver()

	for i = 1, 32 do
		HUDClear( "gameover_" .. i );
	end

	for i = 1, 128 do -- a man can dream
		HUDClear( "gameover_pl" .. i );
	end

	for i = 1, 128 do
		HUDClear( "gameover_pl2" .. i );
	end

	for i = 1, 128 do
		HUDClear( "gameover_plout" .. i );
	end

end

function GM:HUDPaintGameOver()

	if( self:GetState() != STATE_POSTGAME ) then return end
	
	local dt = STATE_TIMES[STATE_POSTGAME] - self:TimeLeftInState();

	surface.BackgroundBlur( 0, 0, ScrW(), ScrH(), math.Clamp( dt, 0, 4 ) / 4 );

	local a = math.Clamp( dt, 0, 1 );

	surface.SetAlphaMultiplier( a );

		surface.SetDrawColor( self:GetSkin().COLOR_GLASS_DARK );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );

		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		surface.SetFont( "COI 18" );		
		local t = I18( "next_round_begins" );
		local w, h = surface.GetTextSize( t );
		surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() - 30 - 40 - 10 - h );
		surface.DrawText( t );

		surface.SetFont( "COI Title 30" );		
		local t = string.ToMinutesSeconds( self:TimeLeftInState() );
		local w, h = surface.GetTextSize( t );
		surface.SetTextPos( ScrW() / 2 - w / 2, ScrH() - h - 40 );
		surface.DrawText( t );

	surface.SetAlphaMultiplier( 1 );

	if( dt < 5 ) then

		surface.SetFont( "COI Title 64" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = I18( "heist" );
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
			local t = I18( "successful" );

			if( LocalPlayer().Safe ) then
				surface.SetTextColor( self:GetSkin().COLOR_SUCCESS );
			else
				surface.SetTextColor( self:GetSkin().COLOR_FAIL );
				t = I18( "failed" );
			end

			local w, h = surface.GetTextSize( t );
			if( dt < 4.3 ) then
				local ym = HUDEase( "gameover_2", 1, -ScrH() * 0.2, ScrH() / 2 - h / 2, 0, 1 );
				surface.SetTextPos( ScrW() / 2 - w / 2, ym );
			else
				local ym = HUDEase( "gameover_4", 0.7, ScrH() / 2 - h / 2, ScrH() * 1.2, 1, 0 );
				surface.SetTextPos( ScrW() / 2 - w / 2, ym );
			end
			surface.DrawText( t );

		end

	elseif( dt < 10 ) then

		for i = 1, 4 do
			HUDClear( "gameover_" .. i );
		end

		local best = 1;
		local bestAmt = -1;
		for k, v in pairs( self.Teams ) do

			local s = team.GetScore( v );
			if( s > bestAmt ) then

				bestAmt = s;
				best = v;

			end

		end

		surface.SetFont( "COI Title 64" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );
		local t = I18( "best_crew" );
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
			surface.SetTextColor( team.GetColor( best ) );
			local t = team.GetName( best );
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

	elseif( dt < 20 ) then

		dt = dt - 10;
		for i = 5, 8 do
			HUDClear( "gameover_" .. i );
		end

		local numTeam = team.NumPlayers( LocalPlayer():Team() );
		local totalY = numTeam * 30 + ( numTeam - 1 ) * 10 + 40 + 64;

		surface.SetFont( "COI Title 64" );
		surface.SetTextColor( team.GetColor( LocalPlayer():Team() ) );
		local t = team.GetName( LocalPlayer():Team() );
		local w, h = surface.GetTextSize( t );
		local dest = ScrH() / 2 - totalY / 2;
		if( dt < 9 ) then
			local ym = HUDEase( "gameover_1", 1, -ScrH() * 0.2, dest, 0, 1 );
			surface.SetTextPos( ScrW() / 2 - w - 40, ym );
		else
			local ym = HUDEase( "gameover_3", 1, dest, ScrH() * 1.2, 1, 0 );
			surface.SetTextPos( ScrW() / 2 - w - 40, ym );
		end
		surface.DrawText( t );

		if( dt > 1 ) then

			local ddt = 0.4 * ( 4 / numTeam );

			surface.SetFont( "COI Title 30" );
			surface.SetTextColor( self:GetSkin().COLOR_WHITE );

			for k, v in pairs( team.GetPlayers( LocalPlayer():Team() ) ) do

				local theirTime = ddt * k;
				if( ( dt - 1 ) > theirTime ) then

					local t = v:Nick();
					local w, h = surface.GetTextSize( t );
					local dest = ScrH() / 2 - totalY / 2 + 64 + 40 + ( 30 + 10 ) * ( k - 1 );
					if( dt < 9 ) then
						local ym = HUDEase( "gameover_pl" .. k, 1, -ScrH() * 0.2, dest, 0, 1 );
						surface.SetTextPos( ScrW() / 2 - w - 40, ym );
					else
						local ym = HUDEase( "gameover_pl2" .. k, 1, dest, ScrH() * 1.2, 1, 0 );
						surface.SetTextPos( ScrW() / 2 - w - 40, ym );
					end
					surface.DrawText( t );

				end

			end

		end

		if( dt > 4 ) then

			local amt = team.GetScore( LocalPlayer():Team() );

			if( dt > 6 and dt < 8 ) then

				local perc = 1 - ( dt - 6 ) / 2;
				amt = math.floor( perc * amt );

			elseif( dt >= 8 ) then

				amt = 0;

			end

			surface.SetFont( "COI Title 64" );
			surface.SetTextColor( self:GetSkin().COLOR_MONEY );
			local t = "$" .. string.Comma( amt );
			local w, h = surface.GetTextSize( t );
			local dest = ScrH() / 2 - totalY / 2;
			if( dt < 9 ) then
				surface.SetTextPos( ScrW() / 2 + 40, dest );
			else
				local ym = HUDEase( "gameover_2", 1, dest, ScrH() * 1.2, 1, 0 );
				surface.SetTextPos( ScrW() / 2 + 40, ym );
			end
			
			surface.DrawText( t );

			surface.SetFont( "COI Title 30" );

			local numTeamSafe = 0;
			for _, v in pairs( team.GetPlayers( LocalPlayer():Team() ) ) do

				if( v.Safe ) then

					numTeamSafe = numTeamSafe + 1;

				end

			end

			for k, v in pairs( team.GetPlayers( LocalPlayer():Team() ) ) do

				local amt = 0;

				if( v.Safe ) then

					if( dt > 6 and dt < 8 ) then

						local perc = ( dt - 6 ) / 2;
						amt = math.floor( perc * team.GetScore( LocalPlayer():Team() ) / numTeamSafe );

					elseif( dt >= 8 ) then

						amt = math.floor( team.GetScore( LocalPlayer():Team() ) / numTeamSafe );

					end

					surface.SetTextColor( self:GetSkin().COLOR_MONEY );
					
				else

					surface.SetTextColor( self:GetSkin().COLOR_FAIL );

				end

				local t = "$" .. string.Comma( amt );
				local w, h = surface.GetTextSize( t );
				local dest = ScrH() / 2 - totalY / 2 + 64 + 40 + ( 30 + 10 ) * ( k - 1 );
				if( dt < 9 ) then
					surface.SetTextPos( ScrW() / 2 + 40, dest );
				else
					local ym = HUDEase( "gameover_plout" .. k, 1, dest, ScrH() * 1.2, 1, 0 );
					surface.SetTextPos( ScrW() / 2 + 40, ym );
				end
				
				surface.DrawText( t );

			end

		end

	elseif( dt < 30 ) then

		dt = dt - 20;

		local y = ScrH() / 2 - ( 20 + 64 + 40 + 64 );

		local awards = { I18( "most_bags_collected" ), I18( "most_money" ), I18( "most_kills" ), I18( "most_knockouts" ), I18( "most_cops" ) };
		surface.SetFont( "COI Title 30" );
		surface.SetTextColor( self:GetSkin().COLOR_WHITE );

		for k, v in pairs( awards ) do

			local t = v;
			local w, h = surface.GetTextSize( t );
			if( dt < 8 ) then
				local xm = HUDEase( "gameover_" .. ( 4 + k * 2 ), 1 + 0.2 * k, -ScrW() * 0.2, ScrW() / 2 - 40 - w, 0, 1 );
				surface.SetTextPos( xm, y );
			else
				local xm = HUDEase( "gameover_" .. ( 5 + k * 2 ), 1 + 0.2 * k, ScrW() / 2 - 40 - w, -ScrW() * 0.2, 1, 0 );
				surface.SetTextPos( xm, y );
			end

			surface.DrawText( t );
			y = y + 64 + 40;

		end

		if( dt > 2 ) then

			local y = ScrH() / 2 - ( 20 + 64 + 40 + 64 ) - 17;

			local best = 1;
			local bestAmt = -1;
			for k, v in pairs( self.Teams ) do

				local s = team.GetScore( v );
				if( s > bestAmt ) then

					bestAmt = s;
					best = v;

				end

			end

			local players = { LocalPlayer(), best, LocalPlayer(), LocalPlayer(), LocalPlayer() };
			local data = { 0, 0, 0, 0, 0 };

			if( self.Stats ) then

				if( self.Stats.MostBags ) then
					players[1] = self.Stats.MostBags;
				end

				if( self.Stats.Bags ) then
					data[1] = self.Stats.Bags;
				end

				if( self.Stats.MostKills ) then
					players[3] = self.Stats.MostKills;
				end

				if( self.Stats.Kills ) then
					data[3] = self.Stats.Kills;
				end

				if( self.Stats.MostKnockouts ) then
					players[4] = self.Stats.MostKnockouts;
				end

				if( self.Stats.Knockouts ) then
					data[4] = self.Stats.Knockouts;
				end

				if( self.Stats.MostCops ) then
					players[5] = self.Stats.MostCops;
				end

				if( self.Stats.Cops ) then
					data[5] = self.Stats.Cops;
				end

			end

			for k, v in pairs( players ) do

				if( type( v ) == "Player" or type( v ) == "Entity" ) then

					if( v and v:IsValid() ) then
						
						surface.SetFont( "COI Title 64" );
						surface.SetTextColor( team.GetColor( v:Team() ) );
						local t = v:Nick();
						local w, h = surface.GetTextSize( t );
						local xm;
						if( dt < 8 ) then
							xm = HUDEase( "gameover_" .. ( 14 + k * 2 ), 1 + 0.2 * k, ScrW() * 1.2, ScrW() / 2 + 40, 0, 1 );
							surface.SetTextPos( xm, y );
						else
							xm = HUDEase( "gameover_" .. ( 15 + k * 2 ), 1 + 0.2 * k, ScrW() / 2 + 40, ScrW() * 1.2, 1, 0 );
							surface.SetTextPos( xm, y );
						end

						surface.DrawText( t );

						if( data[k] and data[k] >= 0 ) then

							surface.SetFont( "COI Title 30" );

							surface.SetTextColor( self:GetSkin().COLOR_WHITE );
							local t = "with " .. data[k];
							surface.SetTextPos( xm + w + 20, y + 34 );

							surface.DrawText( t );

						end

					end

				else

					surface.SetFont( "COI Title 64" );
					surface.SetTextColor( team.GetColor( v ) );
					local t = team.GetName( v );
					local w, h = surface.GetTextSize( t );
					if( dt < 8 ) then
						local xm = HUDEase( "gameover_" .. ( 14 + k * 2 ), 1 + 0.2 * k, ScrW() * 1.2, ScrW() / 2 + 40, 0, 1 );
						surface.SetTextPos( xm, y );
					else
						local xm = HUDEase( "gameover_" .. ( 15 + k * 2 ), 1 + 0.2 * k, ScrW() / 2 + 40, ScrW() * 1.2, 1, 0 );
						surface.SetTextPos( xm, y );
					end

					surface.DrawText( t );

				end

				y = y + 64 + 40;

			end

		end

	end

end

function GM:HUDPaintBlackScreen()

	local a = 0;

	if( self:GetState() == STATE_POSTGAME and self:TimeLeftInState() <= 2 ) then

		if( self:TimeLeftInState() > 1 ) then

			a = 1 - ( self:TimeLeftInState() - 1 );

		else

			a = 1;

		end

		self.PreBlack = true;

	elseif( self:GetState() == STATE_PREGAME and STATE_TIMES[STATE_PREGAME] - self:TimeLeftInState() <= 1.2 and self.PreBlack ) then

		if( STATE_TIMES[STATE_PREGAME] - self:TimeLeftInState() > 0.2 ) then

			a = 1 - ( ( STATE_TIMES[STATE_PREGAME] - self:TimeLeftInState() ) - 0.2 );

		else

			a = 1;

		end

	elseif( self.PreBlack ) then

		self.PreBlack = nil;

	end

	if( a > 0 ) then

		surface.SetDrawColor( Color( 0, 0, 0, a * 255 ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );

	end

end