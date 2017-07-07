AddCSLuaFile();

SWEP.Base = "coi_base";
SWEP.PrintName = "SMG";
SWEP.HoldType = "smg";

SWEP.ViewModel = "models/weapons/c_smg1.mdl";
SWEP.WorldModel = "models/weapons/w_smg1.mdl";
SWEP.UseHands = true;

SWEP.Primary.Ammo = "smg";
SWEP.Primary.Firearm = true;
SWEP.Primary.ClipSize = 45;
SWEP.Primary.DefaultClip = 45;
SWEP.Primary.Automatic = true;
SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );
SWEP.Primary.Delay = 0.075;
SWEP.Primary.Spread = 0.1;
SWEP.Primary.InfiniteAmmo = true;

SWEP.ReloadSound = Sound( "Weapon_SMG1.Reload" );