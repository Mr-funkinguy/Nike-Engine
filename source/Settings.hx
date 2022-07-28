package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import Controls.KeyboardScheme;
import Controls.Control;
import flixel.input.keyboard.FlxKey;
import flixel.FlxCamera;

using StringTools;

class Settings extends MusicBeatSubstate
{
	public static var LowDetail:Bool = false;
	public static var GhostTapping:Bool = true;
	public static var Downscroll:Bool = false;
	public static var Cache:Bool = true;
	public static var RobloxFnFAnimation:Bool = false;

	public static var LeftKEY:FlxKey = A;
	public static var DownKEY:FlxKey = S;
	public static var UpKEY:FlxKey = W;
	public static var RightKEY:FlxKey = D;

	public static var Week2Unlocked:Bool = false;
	public static var Week3Unlocked:Bool = false;
	public static var Week4Unlocked:Bool = false;
	public static var Week5Unlocked:Bool = false;
	public static var Week6Unlocked:Bool = false;
	public static var Week7Unlocked:Bool = false;

	/*
    public static function ChangeSetting(setting:Bool, change:Bool) {
		trace('Changing setting: ' +setting +' to ' +change);
		setting = change;
		LoadShit();
	}
	*/ //this code sucks dick

	public static function LoadShit() {
		trace('Funking with all settings...');
		LoadSettings();
	}

	public static function SettingsSave() {
		trace('Saving new settings...');
		SaveShit();
		LoadSettings();
	}
	
	public static function SaveShit() {
		trace('Saving settings...');
		FlxG.save.data.LowDetail = LowDetail;
		FlxG.save.data.GhostTapping = GhostTapping;
		FlxG.save.data.Downscroll = Downscroll;
		FlxG.save.data.Cache = Cache;
		FlxG.save.data.RobloxFnFAnimation = RobloxFnFAnimation;

		FlxG.save.data.LeftKEY = LeftKEY;
		FlxG.save.data.DownKEY = DownKEY;
		FlxG.save.data.UpKEY = UpKEY;
		FlxG.save.data.RightKEY = RightKEY;

		FlxG.save.data.Week2Unlocked = Week2Unlocked;
		FlxG.save.data.Week3Unlocked = Week3Unlocked;
		FlxG.save.data.Week4Unlocked = Week4Unlocked;
		FlxG.save.data.Week5Unlocked = Week5Unlocked;
		FlxG.save.data.Week6Unlocked = Week6Unlocked;
		FlxG.save.data.Week7Unlocked = Week7Unlocked;
	}

	public static function LoadSettings() {
		trace('Loading settings...');
		if(FlxG.save.data.LowDetail != null) {
			LowDetail = FlxG.save.data.LowDetail;
		}

		if(FlxG.save.data.GhostTapping != null) {
			GhostTapping = FlxG.save.data.GhostTapping;
		}

		if(FlxG.save.data.Downscroll != null) {
			Downscroll = FlxG.save.data.Downscroll;
		}

		if(FlxG.save.data.Cache != null) {
			Cache = FlxG.save.data.Cache;
		}

		if(FlxG.save.data.RobloxFnFAnimation != null) {
			RobloxFnFAnimation = FlxG.save.data.RobloxFnFAnimation;
		}

		if(FlxG.save.data.LeftKEY != null) {
			LeftKEY = FlxG.save.data.LeftKEY;
		}
		if(FlxG.save.data.DownKEY != null) {
			DownKEY = FlxG.save.data.DownKEY;
		}
		if(FlxG.save.data.UpKEY != null) {
			UpKEY = FlxG.save.data.UpKEY;
		}
		if(FlxG.save.data.RightKEY != null) {
			RightKEY = FlxG.save.data.RightKEY;
		}

		if(FlxG.save.data.Week2Unlocked != null) {
			Week2Unlocked = FlxG.save.data.Week2Unlocked;
		}
		if(FlxG.save.data.Week3Unlocked != null) {
			Week3Unlocked = FlxG.save.data.Week3Unlocked;
		}
		if(FlxG.save.data.Week4Unlocked != null) {
			Week4Unlocked = FlxG.save.data.Week4Unlocked;
		}
		if(FlxG.save.data.Week5Unlocked != null) {
			Week5Unlocked = FlxG.save.data.Week5Unlocked;
		}
		if(FlxG.save.data.Week6Unlocked != null) {
			Week6Unlocked = FlxG.save.data.Week6Unlocked;
		}
		if(FlxG.save.data.Week7Unlocked != null) {
			Week7Unlocked = FlxG.save.data.Week7Unlocked;
		}

		SaveShit();
	}
}
