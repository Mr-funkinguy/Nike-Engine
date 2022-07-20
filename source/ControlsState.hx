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
	private var camGame:FlxCamera;
	var credGroup:FlxGroup;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var curSelected:Int = 0;

	var checkbox:FlxSprite;
	var checkbox2:FlxSprite;
	var checkbox3:FlxSprite;

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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.BACKSPACE)
			#if html5
			FlxG.state.openSubState(new OptionsState());
			#else
			LoadingState.loadAndSwitchState(new OptionsState());
			#end

	
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
			curSelected -= 1;
	
		if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
			curSelected += 1;
	
		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
	
		if (curSelected >= textMenuItems.length)
			curSelected = 0;
	
		if (FlxG.keys.justPressed.ENTER)
		{
			switch (textMenuItems[curSelected])
			{
				case "Left":
					if (FlxG.keys.getIsDown().length > 0) {
						PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
					}
				case "Down":
					if (FlxG.keys.getIsDown().length > 0) {
						PlayerSettings.player1.controls.replaceBinding(Control.DOWN, Keys, FlxG.keys.getIsDown()[0].ID, null);
					}
				case "Up":
					if (FlxG.keys.getIsDown().length > 0) {
						PlayerSettings.player1.controls.replaceBinding(Control.UP, Keys, FlxG.keys.getIsDown()[0].ID, null);
					}
				case "Right":
					if (FlxG.keys.getIsDown().length > 0) {
						PlayerSettings.player1.controls.replaceBinding(Control.RIGHT, Keys, FlxG.keys.getIsDown()[0].ID, null);
					}
			}
		}
	}

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
}
