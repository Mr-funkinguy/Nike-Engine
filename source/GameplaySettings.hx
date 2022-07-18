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

		if (controls.UP_P)
			curSelected -= 1;

		if (controls.DOWN_P)
			curSelected += 1;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0; 

		switch (checkbox.animation.curAnim.name)
		{
			case 'selecting animation':
				checkbox.offset.set(17, 70);
			case 'selected':
				checkbox.offset.set();
		}

		switch (checkbox2.animation.curAnim.name)
		{
			case 'selecting animation':
				checkbox.offset.set(17, 70);
			case 'selected':
				checkbox.offset.set();
		}

		switch (checkbox3.animation.curAnim.name)
		{
			case 'selecting animation':
				checkbox.offset.set(17, 70);
			case 'selected':
				checkbox.offset.set();
		}

		WaitingToAccept();
		AlphabetAlpha();
	}

	function AddOptions() {
		money.x += 50;
		money.y += (1 * 80) += 150;
		money.ID = 0;
		money.cameras = [camGame];
		add(money);

		checkbox = new FlxSprite(money.x +325, money.y +15);
		checkbox.frames = Paths.getSparrowAtlas('checkboxThingie');
		checkbox.animation.addByPrefix('selected', 'Check Box Selected Static0', 24, false);
		checkbox.animation.addByPrefix('unselected', 'Check Box unselected0', 24, false);
		checkbox.animation.addByPrefix('selecting animation', 'Check Box selecting animation0', 24, false);
		checkbox.cameras = [camGame];
		checkbox.antialiasing = true;
		checkbox.setGraphicSize(Std.int(checkbox.width * 0.7));
		checkbox.updateHitbox();
		add(checkbox);
		if (Settings.LowDetail) {
			checkbox.animation.play('selected');
		}
		else {
			checkbox.animation.play('unselected');
		}

		money2.x += 50;
		money2.y += (1 * 80) += 300;
		money2.ID = 1;
		money2.cameras = [camGame];
		add(money2);

		checkbox2 = new FlxSprite(money2.x +350, money2.y +15);
		checkbox2.frames = Paths.getSparrowAtlas('checkboxThingie');
		checkbox2.animation.addByPrefix('selected', 'Check Box Selected Static0', 24, false);
		checkbox2.animation.addByPrefix('unselected', 'Check Box unselected0', 24, false);
		checkbox2.animation.addByPrefix('selecting animation', 'Check Box selecting animation0', 24, false);
		checkbox.cameras = [camGame];
		checkbox2.antialiasing = true;
		checkbox2.setGraphicSize(Std.int(checkbox2.width * 0.7));
		checkbox2.updateHitbox();
		add(checkbox2);
		if (Settings.GhostTapping) {
			checkbox2.animation.play('selected');
		}
		else {
			checkbox2.animation.play('unselected');
		}

		money3.x += 50;
		money3.y += (1 * 80) += 450;
		money3.ID = 2;
		money3.cameras = [camGame];
		add(money3);

		checkbox3 = new FlxSprite(money3.x +325, money3.y +15);
		checkbox3.frames = Paths.getSparrowAtlas('checkboxThingie');
		checkbox3.animation.addByPrefix('selected', 'Check Box Selected Static0', 24, false);
		checkbox3.animation.addByPrefix('unselected', 'Check Box unselected0', 24, false);
		checkbox3.animation.addByPrefix('selecting animation', 'Check Box selecting animation0', 24, false);
		checkbox3.cameras = [camGame];
		checkbox3.antialiasing = true;
		checkbox3.setGraphicSize(Std.int(checkbox3.width * 0.7));
		checkbox3.updateHitbox();
		add(checkbox3);
		if (Settings.Downscroll) {
			checkbox3.animation.play('selected');
		}
		else {
			checkbox3.animation.play('unselected');
		}
	}

	function WaitingToAccept() {
		if (controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'));

			if (money.ID == curSelected) {
				if (Settings.LowDetail) {
					trace('changed to false!');
					checkbox.animation.play('unselected');
					Settings.LowDetail = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					checkbox.animation.play('selecting animation');
					Settings.LowDetail = true;
					Settings.SettingsSave();
				}
			}
	
			if (money2.ID == curSelected) {
				if (Settings.GhostTapping) {
					trace('changed to false!');
					checkbox2.animation.play('unselected');
					Settings.GhostTapping = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					checkbox2.animation.play('selecting animation');
					Settings.GhostTapping = true;
					Settings.SettingsSave();
				}
			}
	
			if (money3.ID == curSelected) {
				if (Settings.Downscroll) {
					trace('changed to false!');
					checkbox3.animation.play('unselected');
					Settings.Downscroll = false;
					Settings.SettingsSave();
				}
				else {
					trace('changed to true!');
					checkbox3.animation.play('selecting animation');
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

		checkbox.alpha = 0.6;
		checkbox2.alpha = 0.6;
		checkbox3.alpha = 0.6;

		if (money.ID == curSelected) {
			money.alpha = 1;
			checkbox.alpha = 1;
		}

		if (money2.ID == curSelected) {
			money2.alpha = 1;
			checkbox2.alpha = 1;
		}

		if (money3.ID == curSelected) {
			money3.alpha = 1;
			checkbox3.alpha = 1;
		}
	}
}
