package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class BackgroundHelper extends MusicBeatSubstate
{
	var bg:FlxSprite;

	public function new(image:String, library:String = 'shared', x:Float = 0, y:Float = 0, scrollfactorX:Float = 0.9, scrollfactorY:Float = 0.9, screencenter:Bool = false, animated:Bool = false, xmlcode:String = null, loop:Bool = null)
	{
		if (animated = false) {
			PlayState.bg = new FlxSprite(x, y).loadGraphic(Paths.image(image, library));
			PlayState.bg.scrollFactor.set(scrollfactorX, scrollfactorY);
			PlayState.bg.antialiasing = true;
		}
		else {
			PlayState.bg = new FlxSprite(x, y);
			PlayState.bg.frames = Paths.getSparrowAtlas(image, library);
			PlayState.bg.animation.addByPrefix('animation', xmlcode, 24, loop);
			PlayState.bg.animation.play('animation');
			PlayState.bg.scrollFactor.set(scrollfactorX, scrollfactorY);
			PlayState.bg.antialiasing = true;
		}

		super();
	}
}
