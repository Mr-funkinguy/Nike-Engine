package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var bg:FlxSprite;
	private var coolColors = [0xFF9271FD, 0xFF9271FD, 0xFF223344, 0xFF941653, 0xFFFC96D7, 0xFFA0D1FF, 0xFFFF78BF, 0xFFF6B604];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var Inst:FlxSound = null;
	private var Voices:FlxSound = null;
	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		*/
		#if !html5
		FlxG.sound.music.stop();
		#end

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		//if (StoryMenuState.weekUnlocked[2] || isDebug)
		addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

		if (Settings.Week2Unlocked || isDebug)
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);

		if (Settings.Week3Unlocked || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (Settings.Week4Unlocked || isDebug)
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		if (Settings.Week5Unlocked || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster']);

		if (Settings.Week6Unlocked || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);

		if (Settings.Week7Unlocked || isDebug)
			addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman']);

		addSTANDALONESong('Ferocious', 8, 'garrett-animal'); //add a song alone lol

		/*
		if (sys.FileSystem.exists('assets/editable/weeks/week.txt')) {
			addWeek([Assets.getText(Paths.MODtxt('weeks/week1', [0], 'editable'))], 0, [Assets.getText(Paths.txt('weeks/week1', [1], 'editable'))]);
		}
		*/

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSTANDALONESong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));

		#if PRELOAD_ALL
		if (Settings.Cache) {

			if (FileSystem.exists('assets/songs/' +songName.toLowerCase() +'/Inst.ogg')) {
				FlxG.sound.cache(Paths.inst(songName.toLowerCase()));
			}

			if (FileSystem.exists('assets/songs/' +songName.toLowerCase() +'/Voices.ogg')) {
				FlxG.sound.cache(Paths.voices(songName.toLowerCase()));
			}
			trace('Just loaded: ' + songName.toLowerCase());
			//needed because lag sucks lol
		}
		#end
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			#if PRELOAD_ALL
			if (Settings.Cache) {

				if (FileSystem.exists('assets/songs/' +song.toLowerCase() +'/Inst.ogg')) {
				    FlxG.sound.cache(Paths.inst(song.toLowerCase()));
				}

				if (FileSystem.exists('assets/songs/' +song.toLowerCase() +'/Voices.ogg')) {
					FlxG.sound.cache(Paths.voices(song.toLowerCase()));
				}
				trace('Just loaded: ' + song.toLowerCase());
				//needed because lag sucks lol
			}
			#end

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if html5
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		#end
		//FlxG.sound.music.volume == 0;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (curSelected == 0) { //tutorial
			ChangeBGColor(coolColors[0]);
		}
		else if (curSelected == 1 || curSelected == 2 || curSelected == 3) { //bopeebo, fresh, dadbattle
			ChangeBGColor(coolColors[1]);
		}
		else if (curSelected == 4 || curSelected == 5 || curSelected == 6) { //spookeez, south, monster
			ChangeBGColor(coolColors[2]);
		}
		else if (curSelected == 7 || curSelected == 8 || curSelected == 9) { //pico, philly, blammed
			ChangeBGColor(coolColors[3]);
		}
		else if (curSelected == 10 || curSelected == 11 || curSelected == 12) { //satin-panties, high, milf
			ChangeBGColor(coolColors[4]);
		}
		else if (curSelected == 13 || curSelected == 14 || curSelected == 15) { //cocoa, eggnog, winter-horrorland
			ChangeBGColor(coolColors[5]);
		}
		else if (curSelected == 16 || curSelected == 17 || curSelected == 18) { //senpai, roses, thorns
			ChangeBGColor(coolColors[6]);
		}
		else if (curSelected == 19 || curSelected == 20 || curSelected == 21) { //ugh, guns, stress
			ChangeBGColor(coolColors[7]);
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			#if PRELOAD_ALL
			if (Inst != null) {
				Inst.destroy();
			}
	
			if (Voices != null) {
				Voices.destroy();
			}
			#end

			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			#if PRELOAD_ALL
			if (Inst != null) {
				Inst.destroy();
			}
	
			if (Voices != null) {
				Voices.destroy();
			}
			#end

			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function ChangeBGColor(color:Dynamic) {
		bg.color = color;
		//FlxTween.tween(bg, {color: color}, 0.2);
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		//Inst.pause();

		if (Inst != null) {
			Inst.destroy();
		}
		Inst = new FlxSound().loadEmbedded(Paths.inst(songs[curSelected].songName));
		Inst.persist = true;

		if (Voices != null) {
			Voices.destroy();
		}

		if (curSelected != 0) {
			Voices = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));
			Voices.persist = true;
		}

		Inst.play();
		if (curSelected != 0) {
			Voices.play();
		}
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
