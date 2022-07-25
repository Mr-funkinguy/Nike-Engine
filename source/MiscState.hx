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

class MiscState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['1'];
	/*
	var textMenuItem2:Array<String> = ['Controls'];
	var textMenuItem3:Array<String> = ['Misc'];
	*/
	var credGroup:FlxGroup;

	private var camGame:FlxCamera;

	var offset:Int = 50;
	var money:Alphabet = new Alphabet(0, 0, 'Roblox FNF Mode', false, false);

	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var checkbox:FlxSprite;
	var checkbox2:FlxSprite;
	var checkbox3:FlxSprite;

	public function new()
	{
		super();
	}

	override public function create()
	{
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camGame);

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		AddOptions();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK) {
			#if html5
			FlxG.switchState(new OptionsState());
			#else
			LoadingState.loadAndSwitchState(new OptionsState());
			#end
		}


		if (controls.UP_P) {
			curSelected -= 1;
	    }

		if (controls.DOWN_P) {
			curSelected += 1;
		}

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0; 

		switch (checkbox.animation.curAnim.name)
		{
			case 'selecting animation':
				checkbox.offset.set(17, 70);
			case 'unselected':
				checkbox.offset.set();
		}

		WaitingToAccept();
		AlphabetAlpha();
	}

	function AddOptions() {
		money.x += 50;
		money.y += (1 * 80);
		money.ID = 0;
		money.cameras = [camGame];
		add(money);

		checkbox = new FlxSprite(money.width +50, money.y +15);
		checkbox.frames = Paths.getSparrowAtlas('checkboxThingie');
		checkbox.animation.addByPrefix('selected', 'Check Box Selected Static0', 24, false);
		checkbox.animation.addByPrefix('unselected', 'Check Box unselected0', 24, false);
		checkbox.animation.addByPrefix('selecting animation', 'Check Box selecting animation0', 24, false);
		checkbox.cameras = [camGame];
		checkbox.antialiasing = true;
		checkbox.setGraphicSize(Std.int(checkbox.width * 0.7));
		checkbox.updateHitbox();
		add(checkbox);
		if (Settings.RobloxFnFAnimation) {
			checkbox.animation.play('selecting animation');
		}
		else {
			checkbox.animation.play('unselected');
		}
	}

	function WaitingToAccept() {
		if (controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'));

			if (money.ID == curSelected) {
				if (Settings.RobloxFnFAnimation) {
					trace('changed to false!');
					checkbox.animation.play('unselected');
					Settings.RobloxFnFAnimation = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					checkbox.animation.play('selecting animation');
					Settings.RobloxFnFAnimation = true;
					Settings.SettingsSave();
				}
			}
		}
	}

	function AlphabetAlpha() {
		money.alpha = 0.6;

		checkbox.alpha = 0.6;

		if (money.ID == curSelected) {
			money.alpha = 1;
			checkbox.alpha = 1;
		}
	}
}