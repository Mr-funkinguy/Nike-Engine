package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import Controls.KeyboardScheme;
import Controls.Control;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.FlxCamera;

class ControlsState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Left', 'Down', 'Up', 'Right', 'Reset to default.'];
	var money:Alphabet = new Alphabet(0, 0, "Left Keybind is " +Settings.LeftKEY, false, false);
	var money2:Alphabet = new Alphabet(0, 0, "Down Keybind is " +Settings.DownKEY, false, false);
	var money3:Alphabet = new Alphabet(0, 0, "Up Keybind is " +Settings.UpKEY, false, false);
	var money4:Alphabet = new Alphabet(0, 0, "Right Keybind is " +Settings.RightKEY, false, false);
	var money5:Alphabet = new Alphabet(0, 0, 'Reset to default.', false, false);
	private var camGame:FlxCamera;
	var credGroup:FlxGroup;

	//waiting shit
	var blackScreen:FlxSprite;
	var CanPress:Bool = false;
	var waiting:Alphabet = new Alphabet(0, 0, 'Press a key to set', true, false);
	var waitingP2:Alphabet = new Alphabet(0, 0, 'your keybinds.', true, false);

	//keybind reset!!!
	var keybindsreset:Alphabet = new Alphabet(0, 0, 'Keybinds have been reset', true, false);

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	public static var curSelected:Int = 0;

	var checkbox:FlxSprite;
	var checkbox2:FlxSprite;
	var checkbox3:FlxSprite;

	var LoadedIntoState:Bool = false;

	override function create() 
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
		
		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);
		
		credGroup = new FlxGroup();
		add(credGroup);

		createText();

		blackScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		blackScreen.visible = false;
		blackScreen.alpha = 0.4;
		add(blackScreen);

		waiting.cameras = [camGame];
		waiting.visible = false;
		waiting.screenCenter(X);
		waiting.y = 250;
		add(waiting);

		waitingP2.cameras = [camGame];
		waitingP2.visible = false;
		waitingP2.screenCenter();
		add(waitingP2);

		keybindsreset.cameras = [camGame];
		keybindsreset.visible = false;
		keybindsreset.screenCenter();
		keybindsreset.alpha = 1;
		add(keybindsreset);
		//createCoolText(textMenuItems);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE && !CanPress || FlxG.keys.justPressed.BACKSPACE && !CanPress)
			#if html5
			FlxG.state.openSubState(new OptionsState());
			#else
			LoadingState.loadAndSwitchState(new OptionsState());
			#end
		else if (FlxG.keys.justPressed.ESCAPE && CanPress || FlxG.keys.justPressed.BACKSPACE && CanPress) {
			HideSHIT(false, false);
			CanPress = false;
		}

		/*
		money.text = "Left Keybind: " +Settings.LeftKEY;
		money2.text = "Down Keybind: " +Settings.DownKEY;
		money3.text = "Up Keybind: " +Settings.UpKEY;
		money4.text = "Right Keybind: " +Settings.RightKEY;
		*/
	
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
			curSelected -= 1;
	
		if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
			curSelected += 1;
	
		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
	
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		if (money5.ID == curSelected && FlxG.keys.justPressed.ENTER) {
			Settings.LeftKEY = A;
			Settings.DownKEY = S;
			Settings.UpKEY = W;
			Settings.RightKEY = D;

			HideSHIT(true, true, true);
			trace('Reset keys to default.');
		}

		/*
		if (credGroup.money.ID == curSelected) {
			credGroup.money.alpha = 1;
		}

		if (credGroup.money.ID != curSelected) {
			credGroup.money.alpha = 0.6;
		}
		*/

		AlphabetAlpha();
	
		if (FlxG.keys.justReleased.ENTER && money5.ID != curSelected && LoadedIntoState)
		{
			//trace('HOLY SHIT 0'); //did these cause game crashed lol!
			blackScreen.visible = true;
			waiting.visible = true;
			waitingP2.visible = true;

			new FlxTimer().start(0.05, function(tmr:FlxTimer) {
				CanPress = true;
			});
		}

		if (CanPress && !FlxG.keys.justReleased.ENTER && !FlxG.keys.justPressed.ENTER && !FlxG.keys.pressed.ENTER) {
			if (FlxG.keys.getIsDown().length > 0) {

				switch (textMenuItems[curSelected])
				{
					case "Left":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								Settings.LeftKEY = FlxG.keys.getIsDown()[0].ID;
								//PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New LEFT KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
						}
					case "Down":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								Settings.DownKEY = FlxG.keys.getIsDown()[0].ID;
								//PlayerSettings.player1.controls.replaceBinding(Control.DOWN, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New DOWN KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
					    }
					case "Up":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								Settings.UpKEY = FlxG.keys.getIsDown()[0].ID;
								//PlayerSettings.player1.controls.replaceBinding(Control.UP, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New UP KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
					    }
					case "Right":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								Settings.RightKEY = FlxG.keys.getIsDown()[0].ID;
								//PlayerSettings.player1.controls.replaceBinding(Control.RIGHT, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New RIGHT KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
					    }
				}
			}
		}
	}

	function HideSHIT(?sound:Bool = true, ?save:Bool = true, ?reset:Bool = false) {
		blackScreen.visible = false;
		waiting.visible = false;
		waitingP2.visible = false;
		CanPress = false;

		if (sound) {
			FlxG.sound.play(Paths.sound('confirmMenu'));
		}
		else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (reset) {
			blackScreen.visible = true;
			keybindsreset.visible = true;

			FlxTween.tween(blackScreen, {alpha: 0}, 1.25);
			FlxTween.tween(keybindsreset, {alpha: 0}, 1.25, {
				onComplete: function(twn:FlxTween)
				{
					blackScreen.visible = false;
					blackScreen.alpha = 0.4;
					keybindsreset.visible = false;
					keybindsreset.alpha = 1;
				}
			});
		}

		if (save) {
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
			Settings.SettingsSave();
			var FuckMyLife:Int = curSelected;
			FlxG.switchState(new ControlsState());
			ControlsState.curSelected = FuckMyLife;
		}
	}

	function createText() {
		money.x += 50;
		money.y += (1 * 80) += -50;
		money.ID = 0;
		money.cameras = [camGame];
		credGroup.add(money);

		money2.x += 50;
		money2.y += (2 * 80) += -50;
		money2.ID = 1;
		money2.cameras = [camGame];
		credGroup.add(money2);

		money3.x += 50;
		money3.y += (3 * 80) += -50;
		money3.ID = 2;
		money3.cameras = [camGame];
		credGroup.add(money3);

		money4.x += 50;
		money4.y += (4 * 80) += -50;
		money4.ID = 3;
		money4.cameras = [camGame];
		credGroup.add(money4);

		money5.x += 50;
		money5.y += (7 * 80) += -50;
		money5.ID = 4;
		money5.cameras = [camGame];
		credGroup.add(money5);

		trace('Waiting 0.25 seconds to load shit...');
		new FlxTimer().start(0.25, function(tmr:FlxTimer) {
			LoadedIntoState = true;
			trace('LOADED');
		});
	}

	/*
	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length) {
			var money:Alphabet = new Alphabet(0, 0, textArray[i], false, true);
			money.screenCenter(X);
			money.y += (i * 80) + 200;
			money.ID = i;
			credGroup.add(money);
		}
	}
	*/

	function AlphabetAlpha() {
		money.alpha = 0.6;
		money2.alpha = 0.6;
		money3.alpha = 0.6;
		money4.alpha = 0.6;
		money5.alpha = 0.6;

		if (money.ID == curSelected) {
			money.alpha = 1;
		}

		if (money2.ID == curSelected) {
			money2.alpha = 1;
		}

		if (money3.ID == curSelected) {
			money3.alpha = 1;
		}

		if (money4.ID == curSelected) {
			money4.alpha = 1;
		}

		if (money5.ID == curSelected) {
			money5.alpha = 1;
		}
	}
}
