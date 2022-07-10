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

class GameplaySettings extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Low Detail', 'Ghost Tapping', 'Downscroll'];
	/*
	var textMenuItem2:Array<String> = ['Controls'];
	var textMenuItem3:Array<String> = ['Misc'];
	*/
	var credGroup:FlxGroup;

	private var camGame:FlxCamera;

	var money:Alphabet = new Alphabet(0, 0, 'Low Detail', false, false);
	var money2:Alphabet = new Alphabet(0, 0, 'Ghost Tapping', false, false);
	var money3:Alphabet = new Alphabet(0, 0, 'Downscroll', false, false);

	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	public function new()
	{
		super();

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
	}

	override public function create()
	{
		money.x += 50;
		money.y += (1 * 80) += 150;
		money.ID = 0;
		money.cameras = [camGame];
		add(money);

		money2.x += 50;
		money2.y += (1 * 80) += 300;
		money2.ID = 1;
		money2.cameras = [camGame];
		add(money2);

		money3.x += 50;
		money3.y += (1 * 80) += 450;
		money3.ID = 2;
		money3.cameras = [camGame];
		add(money3);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK) {
			LoadingState.loadAndSwitchState(new OptionsSubState());
		}

		if (controls.UP_P)
			curSelected -= 1;

		if (controls.DOWN_P)
			curSelected += 1;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0; 

		WaitingToAccept();
		AlphabetAlpha();
	}

	function WaitingToAccept() {
		if (controls.ACCEPT) {

			FlxG.sound.play(Paths.sound('confirmMenu'));

			if (money.ID == curSelected) {
				if (Settings.LowDetail) {
					trace('changed to false!');
					Settings.LowDetail = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					Settings.LowDetail = true;
					Settings.SettingsSave();
				}
			}
	
			if (money2.ID == curSelected) {
				if (Settings.GhostTapping) {
					trace('changed to false!');
					Settings.GhostTapping = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					Settings.GhostTapping = true;
					Settings.SettingsSave();
				}
			}
	
			if (money3.ID == curSelected) {
				if (Settings.Downscroll) {
					trace('changed to false!');
					Settings.Downscroll = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					Settings.Downscroll = true;
					Settings.SettingsSave();
				}
			}
		}
	}

	function AlphabetAlpha() {
		money.alpha = 0.6;
		money2.alpha = 0.6;
		money3.alpha = 0.6;

		if (money.ID == curSelected) {
			money.alpha = 1;
		}

		if (money2.ID == curSelected) {
			money2.alpha = 1;
		}

		if (money3.ID == curSelected) {
			money3.alpha = 1;
		}
	}
}
