package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import Controls.Control;
import lime.app.Application;
import flixel.FlxSubState;

class ControlsSubState extends FlxSubState
{
	var textMenuItems:Array<String> = ['Left', 'Down', 'Up', 'Right'];
	var credGroup:FlxGroup;

	var curSelected:Int = 0;

	public function new()
	{
		super();

		credGroup = new FlxGroup();
		add(credGroup);

		createCoolText(textMenuItems);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
			FlxG.state.closeSubState();
		    FlxG.state.openSubState(new OptionsSubState());
	
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
