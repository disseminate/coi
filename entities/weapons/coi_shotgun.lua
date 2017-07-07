AddCSLuaFile();

SWEP.Base = "coi_base";
SWEP.PrintName = "Shotgun";
SWEP.HoldType = "shotgun";

SWEP.ViewModel = "models/weapons/c_shotgun.mdl";
SWEP.WorldModel = "models/weapons/w_shotgun.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "buckshot";
SWEP.Primary.Firearm = true;
SWEP.Primary.ClipSize = 6;
SWEP.Primary.DefaultClip = 6;
SWEP.Primary.Automatic = false;
SWEP.Primary.Sound = Sound( "Weapon_Shotgun.Single" );
SWEP.Primary.Delay = 0.4;
SWEP.Primary.Spread = 0.08716;
SWEP.Primary.InfiniteAmmo = true;
SWEP.Primary.Num = 8;
SWEP.Primary.Force = 3;

SWEP.ShotgunReload = true;
SWEP.ReloadSound = Sound( "Weapon_Shotgun.Reload" );