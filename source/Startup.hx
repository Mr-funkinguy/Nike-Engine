package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import lime.app.Application;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.FlxGraphic;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Startup extends MusicBeatState
{
	var bg:FlxSprite;
	public static var e:String = 'icons/icon-';
	var songs = ['tutorial', 'bopeebo', 'fresh', 'dadbattle', 'spookeez', 'south', 'monster', 'pico', 'philly', 'blammed', 'satin-panties',
    'high', 'milf', 'cocoa', 'eggnog', 'winter-horrorland', 'senpai', 'roses', 'thorns', 'ugh', 'guns', 'stress'];

	var bitmapData:Map<String, FlxGraphic>;
	public static var images = ['iconGrid', 'logoBumpin', 'gfDanceTitle', 'alphabet', 'newgrounds_logo', 'menuBG', 'menuBGBlue', 'menuBGMagenta', 'menuBGDesat', 
	'funkay', 'FNF_main_menu_assets', 'num0', 'num1', 'num2', 'num3', 'num4', 'num5', 'num6', 'num7', 'num8', 'num9', e + 'bf', e + 'gf', e + 'dad', e + 'spooky',
	e + 'monster', e + 'pico', e + 'mom', e + 'parents-christmas', e + 'bf-pixel', e + 'gf-pixel', e + 'senpai-pixel', e + 'spirit-pixel', e + 'tankman', e + 'face'];

	public static var imagesSHARED = ['sick', 'good', 'bad', 'shit', 'noteSplashes', 'NOTE_assets', 'ready', 'set', 'go'];

	public static var imagesCHARS = ['characters/BOYFRIEND', 'characters/GF_assets', 'characters/DADDY_DEAREST', 'characters/spooky_kids_assets', 'characters/Monster_Assets', 
	'characters/Pico_FNF_assetss', 'characters/bfCar', 'characters/gfCar', 'characters/Mom_Assets', 'characters/bfChristmas', 'characters/gfChristmas', 'characters/mom_dad_christmas_assets', 
	'characters/bfPixel', 'characters/gfPixel', 'characters/senpai', 'characters/spirit', 'characters/tankmanCaptain', 'characters/bfAndGF', 'characters/gfTankmen', 'characters/picoSpeaker'];

	override function create()
	{
		bg = new FlxSprite().loadGraphic(Paths.image('funkay'));
		bg.screenCenter();
		add(bg);

		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		Highscore.load();
		Settings.LoadSettings();
		controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		trace("Loaded keybinds.");

		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end

		if (Settings.Cache) {
			Cache();
		}
		else {
			Start();
		}
	}

	function Start() {
		trace('Finished!');
		FlxG.switchState(new TitleState());
	}

	function Cache() {
		for (i in 0...images.length) {
			trace(images[i]);
		}

		for (i in 0...imagesSHARED.length) {
			trace(imagesSHARED[i]);
		}

		for (i in 0...imagesCHARS.length) {
			trace(imagesCHARS[i]);
		}

		for (i in 0...songs.length) {
			#if PRELOAD_ALL
			FlxG.sound.cache(Paths.inst(songs[i]));
			if (FileSystem.exists('assets/songs/' +songs[i] +'/Voices.ogg')) {
				FlxG.sound.cache(Paths.voices(songs[i]));
			}
			trace('Just loaded: ' + songs[i]);
			#end
		}
		
		/* //null object reference
		for (i in 0...images.length) {
			var path = Paths.image(images[i]);
			var data = OpenFlAssets.getBitmapData(path);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(images[i], graph);
			//kade engine code because I can't figure out any image precaching code
		}
		*/

		trace('Finished Caching!');
		Start();
	}
}