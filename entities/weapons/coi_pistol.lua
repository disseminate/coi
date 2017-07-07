AddCSLuaFile();

SWEP.Base = "coi_base";
SWEP.PrintName = "Pistol";
SWEP.HoldType = "pistol";

SWEP.ViewModel = "models/weapons/c_pistol.mdl";
SWEP.WorldModel = "models/weapons/w_pistol.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "pistol";
SWEP.Primary.Firearm = true;
SWEP.Primary.ClipSize = 18;
SWEP.Primary.DefaultClip = 18;
SWEP.Primary.Automatic = false;
SWEP.Primary.Sound = Sound( "Weapon_Pistol.Single" );
SWEP.Primary.Delay = 0.1;
SWEP.Primary.Spread = 0.02;
SWEP.Primary.InfiniteAmmo = true;

SWEP.ReloadSound = Sound( "Weapon_Pistol.Reload" );