package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var inCutscene:Bool = false;

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var PixelSONG:Bool = false;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				PixelSONG = true;
			case 'roses':
				PixelSONG = true;
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				PixelSONG = true;
			default:
				FlxG.sound.playMusic(Paths.music('breakfast', 'shared'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.updateHitbox();

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open0', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal0', 24, true);
				box.animation.addByPrefix('AHHH', 'AHH speech bubble0', 24, true);
				box.updateHitbox();
				box.scale.set(0.85, 0.85);
				box.y += 335;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'senpai' | 'roses' | 'thorns':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
		
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			default:
				portraitLeft = new FlxSprite(-20, 40).loadGraphic(Paths.image('portraits/' + PlayState.SONG.player2, 'shared'));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				if (PlayState.SONG.player2 == 'dad' || PlayState.SONG.player2 == 'spooky') {
					portraitLeft.y += 100;
				}
				else {
					portraitLeft.y += 200;
				}
				portraitLeft.x += 200;
				add(portraitLeft);
				portraitLeft.visible = false;
		
				portraitRight = new FlxSprite(0, 40).loadGraphic(Paths.image('portraits/' + PlayState.SONG.player1, 'shared'));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				portraitRight.y += 200;
				portraitRight.x += 650;
				add(portraitRight);
				portraitRight.visible = false;
		}
		
		box.animation.play('normalOpen');
		add(box);

		box.screenCenter(X);

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns') {
			portraitLeft.screenCenter(X);
		}
		
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'senpai' | 'roses' | 'thorns':
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				add(handSelect);
			default:
				trace('No hand thingy lol');
		}


		if (!talkingRight)
		{
			// box.flipX = true;
		}

				
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'senpai' | 'roses' | 'thorns':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0xFFD89494;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFF3F2021;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
			default:
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = Paths.font('comic.ttf');
				dropText.color = FlxColor.WHITE;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = Paths.font('comic.ttf');
				swagDialogue.color = FlxColor.BLACK;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
		}

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns') {
						FlxG.sound.music.fadeOut(2.2, 0);
					}
					else if (PlayState.SONG.song.toLowerCase() != 'senpai') {
						FlxG.sound.music.fadeOut(2.2, 0);
					}

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
					    portraitLeft.alpha -= 1 / 5;
						portraitRight.alpha -= 1 / 5;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function ChangeDialogueCHAR(CHAR:String, ?Y:Int = 200) {
		remove(portraitLeft);
		portraitLeft = new FlxSprite(-20, 40).loadGraphic(Paths.image('portraits/' + CHAR, 'shared'));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.y += Y;
		portraitLeft.x += 200;
		add(portraitLeft);

		portraitRight.visible = false;
		if (!portraitLeft.visible)
		{
			portraitLeft.visible = true;
			if (PixelSONG) {
				portraitLeft.animation.play('enter');
			}
		}
		trace('new char!');
	}

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'monster':
				ChangeDialogueCHAR('monster');
			case 'spooky':
				ChangeDialogueCHAR('spooky', 100);
			case 'gf':
				ChangeDialogueCHAR('gf');
			case 'sore':
				ChangeDialogueCHAR('sore', 100);
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					if (PixelSONG) {
						portraitLeft.animation.play('enter');
					}
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					if (PixelSONG) {
						portraitRight.animation.play('enter');	
					}
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
