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
	var songs = ['tutorial', 'bopeebo', 'fresh', 'dadbattle', 'spookeez', 'south', 'monster', 'pico', 'philly', 'blammed', 'satin-panties',
    'high', 'milf', 'cocoa', 'eggnog', 'winter-horrorland', 'senpai', 'roses', 'thorns', 'ugh', 'guns', 'stress'];

	var bitmapData:Map<String, FlxGraphic>;
	var images = ['iconGrid', 'logoBumpin', 'gfDanceTitle', 'alphabet', 'newgrounds_logo', 'menuBG', 'menuBGBlue', 'menuBGMagenta', 'menuBGDesat', 
	'funkay', 'FNF_main_menu_assets'];

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