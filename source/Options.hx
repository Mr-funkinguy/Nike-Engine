package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class Options extends MusicBeatSubstate
{
	var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
	menuBG.color = 0xFFea71fd;
	menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
	menuBG.updateHitbox();
	menuBG.screenCenter();
	menuBG.antialiasing = true;
	add(menuBG);
}
