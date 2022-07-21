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
import Controls.Control;

class ControlsState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Left', 'Down', 'Up', 'Right'];
	var money:Alphabet = new Alphabet(0, 0, 'Left', false, false);
	var money2:Alphabet = new Alphabet(0, 0, 'Down', false, false);
	var money3:Alphabet = new Alphabet(0, 0, 'Up', false, false);
	var money4:Alphabet = new Alphabet(0, 0, 'Right', false, false);
	private var camGame:FlxCamera;
	var credGroup:FlxGroup;

	//waiting shit
	var blackScreen:FlxSprite;
	var CanPress:Bool = false;
	var waiting:Alphabet = new Alphabet(0, 0, 'Press a key to set', true, false);
	var waitingP2:Alphabet = new Alphabet(0, 0, 'your keybinds.', true, false);

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var curSelected:Int = 0;

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
			HideSHIT(false);
			CanPress = false;
		}

	
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
			curSelected -= 1;
	
		if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
			curSelected += 1;
	
		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
	
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		/*
		if (credGroup.money.ID == curSelected) {
			credGroup.money.alpha = 1;
		}

		if (credGroup.money.ID != curSelected) {
			credGroup.money.alpha = 0.6;
		}
		*/

		AlphabetAlpha();
	
		if (FlxG.keys.justReleased.ENTER && LoadedIntoState)
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
								FlxG.save.data.LeftKEY = FlxG.keys.getIsDown()[0].ID;
								PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New LEFT KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
						}
					case "Down":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								FlxG.save.data.DownKEY = FlxG.keys.getIsDown()[0].ID;
								PlayerSettings.player1.controls.replaceBinding(Control.DOWN, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New DOWN KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
					    }
					case "Up":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								FlxG.save.data.UpKEY = FlxG.keys.getIsDown()[0].ID;
								PlayerSettings.player1.controls.replaceBinding(Control.UP, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New UP KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
					    }
					case "Right":
						if (!FlxG.keys.justPressed.ESCAPE && !FlxG.keys.justPressed.BACKSPACE && !FlxG.keys.justPressed.ENTER && !FlxG.keys.justPressed.DELETE) {
							if (FlxG.keys.getIsDown().length > 0) {
								FlxG.save.data.RightKEY = FlxG.keys.getIsDown()[0].ID;
								PlayerSettings.player1.controls.replaceBinding(Control.RIGHT, Keys, FlxG.keys.getIsDown()[0].ID, null);
							}
							trace('New RIGHT KEY IS: ' + FlxG.keys.getIsDown()[0].ID);
							HideSHIT();
					    }
				}
			}
		}
	}

	function HideSHIT(?sound:Bool = true) {
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

		trace('Waiting 0.5 seconds to load shit...');
		new FlxTimer().start(0.5, function(tmr:FlxTimer) {
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
	}
}
