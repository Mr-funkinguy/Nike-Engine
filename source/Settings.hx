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
import flixel.FlxCamera;

using StringTools;

class Settings extends MusicBeatSubstate
{
	public static var LowDetail:Bool = false;
	public static var GhostTapping:Bool = true;
	public static var Downscroll:Bool = false;

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

		SaveShit();
	}
}
