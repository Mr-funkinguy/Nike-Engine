package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import lime.utils.AssetCache;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var practiceMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var deathCounter:Int = 0;
	public var songStarted = false;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	var lostfocuspause:FlxSprite;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var opponentStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	//tankman shit
	var smokeL:FlxSprite;
	var smokeR:FlxSprite;
	var tankWatchtower:FlxSprite;
	var tankGround:FlxSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var tankdude1:FlxSprite;
	var tankdude2:FlxSprite;
	var tankdude3:FlxSprite;
	var tankdude4:FlxSprite;
	var tankdude5:FlxSprite;
	var tankdude6:FlxSprite;

	//helper shit
	public static var bg:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songTxt:FlxText;
	var missesTxt:FlxText;
	var scoreTxt:FlxText;
	var ratingTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	var misses:Int = 0;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	//healthbar shit lol
	private var OpponentHealthbar:Dynamic = 0xFFFF0000;
	private var BFHealthbar:Dynamic = 0xFFA0D1FF;
	//healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);

	//score
	private var PixelSONG:Bool = false;
	private var week7zoom:Bool = false;
	//private var tankmanHEAVEN:Bool = false;
	private var score:Int = 0;
	private var daRating:String = "";

	private var DialoguePath:Array<String> = CoolUtil.coolTextFile(Paths.txt('tutorial/tutorialDialogue'));

	//noteslash
	private var babyArrow:FlxSprite;
	//var notesplash:FlxSprite;

	#if !html5
	//mod shit!!!!
	var modSTAGE:FlxGroup;
	var modStageFILE = CoolUtil.coolTextFile('assets/editable/stages/README.txt');
	var stageMOD:Bool = false;
	var songName:String = '';
	#end

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var camPos:FlxPoint;

	var ForceCameraInCenter:Bool = false;

	//LOL XD
	var schoolSTATIC:FlxSprite;
	var RUNBITCH:FlxSprite;
	var RUNBITCHSTATIC:FlxSprite;
	var BFLEGS2:FlxSprite;
	var Jail:FlxSprite;
	var blackScreen:FlxSprite;
	var blackScreenBG:FlxSprite;
	var IPADBG:FlxSprite;
	var IPAD:FlxSprite;
	var PEDOPHILESTATIC:FlxSprite;
	var POLICECAR:FlxSprite;

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial-hard', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		if (Settings.Cache) {
			var lolXD = Startup.images;
			var lolXD2 = Startup.imagesSHARED;
			var lolXD3 = Startup.imagesCHARS;

			for (i in 0...lolXD.length) {
				CacheIMAGE(lolXD[i]);
			}

			for (i in 0...lolXD2.length) {
				CacheIMAGE(lolXD2[i], true);
			}

			for (i in 0...lolXD3.length) {
				CacheIMAGE(lolXD3[i], true);
			}

			//load assets xd
		}

		#if !html5
		modSTAGE = new FlxGroup();
		add(modSTAGE);

		if (sys.FileSystem.exists('assets/editable/stages/' +SONG.song.toLowerCase() +'.txt')) {
			modStageFILE = CoolUtil.coolTextFile('assets/editable/stages/' +SONG.song.toLowerCase() +'.txt');
			stageMOD = true;
		}

		songName = '' + SONG.song;
		songName.toLowerCase();
		#end

		/*
		if (songName == 'tutorial' || 'bopeebo' || 'fresh' || 'dadbattle') {
			songName = '';
		}
		*/

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'bopeebo':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'fresh':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'dadbattle':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'spookeez':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'south':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'monster':
				DialoguePath = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' +SONG.song.toLowerCase() + 'Dialogue'));
				dialogue = DialoguePath;
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek + "(" +storyDifficulty + ")";
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		switch (SONG.song.toLowerCase())
		{
            case 'spookeez' | 'monster' | 'south': {
                curStage = 'spooky';
	            halloweenLevel = true;

		        var hallowTex = Paths.getSparrowAtlas('halloween_bg');

	            halloweenBG = new FlxSprite(-200, -100);
		        halloweenBG.frames = hallowTex;
	            halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	            halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	            halloweenBG.animation.play('idle');
	            halloweenBG.antialiasing = true;
	            add(halloweenBG);

		        isHalloween = true;
		    }
		    case 'pico' | 'blammed' | 'philly': {
		        curStage = 'philly';

		        var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
		        bg.scrollFactor.set(0.1, 0.1);
		        add(bg);

				if (!Settings.LowDetail) {
					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);
	
					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);
	
					for (i in 0...5) {
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}
	
					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					add(phillyTrain);
	
					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);
				}

		        // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		        var street:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/street'));
	            add(street);
		    }
		    case 'milf' | 'satin-panties' | 'high': {
		        curStage = 'limo';
		        defaultCamZoom = 0.90;

		        var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
		        skyBG.scrollFactor.set(0.1, 0.1);
		        add(skyBG);

				if (!Settings.LowDetail) {
					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
	
					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);
	
					for (i in 0...5) {
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}
	
					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
					overlayShit.alpha = 0.5;
					/*
					add(overlayShit);

					var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);
					FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);
					overlayShit.shader = shaderBullshit;
					*/
				}

		        var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

		        limo = new FlxSprite(-120, 550);
		        limo.frames = limoTex;
		        limo.animation.addByPrefix('drive', "Limo stage", 24);
		        limo.animation.play('drive');
		        limo.antialiasing = true;

				if (!Settings.LowDetail) {
					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);
				}
		    }
		    case 'cocoa' | 'eggnog': {
	            curStage = 'mall';

		        defaultCamZoom = 0.80;

		        var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
		        bg.antialiasing = true;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();
		        add(bg);

				if (!Settings.LowDetail) {
					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);
				}

		        var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
		        bgEscalator.antialiasing = true;
		        bgEscalator.scrollFactor.set(0.3, 0.3);
		        bgEscalator.active = false;
		        bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		        bgEscalator.updateHitbox();
		        add(bgEscalator);

				if (!Settings.LowDetail) {
					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);
	
					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);
				}

		        var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		        fgSnow.active = false;
		        fgSnow.antialiasing = true;
		        add(fgSnow);

				if (!Settings.LowDetail) {
					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					add(santa);
				}
		    }
		    case 'winter-horrorland': {
		        curStage = 'mallEvil';
		        var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
		        bg.antialiasing = true;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();
		        add(bg);

				if (!Settings.LowDetail) {
					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);
				}

		        var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
	            evilSnow.antialiasing = true;
		        add(evilSnow);
            }
		    case 'senpai' | 'roses': {
		        curStage = 'school';

		        // defaultCamZoom = 0.9;

		        var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
		        bgSky.scrollFactor.set(0.1, 0.1);
		        add(bgSky);

		        var repositionShit = -200;
				var widShit = Std.int(bgSky.width * 6);

				if (!Settings.LowDetail) {
					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					bgSchool.setGraphicSize(widShit);
					bgSchool.updateHitbox();
				}

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

				if (!Settings.LowDetail) {
					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);
	
					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);
	
					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();
				}

				bgSky.setGraphicSize(widShit);
		        bgStreet.setGraphicSize(widShit);
		        bgSky.updateHitbox();
				bgStreet.updateHitbox();

				if (!Settings.LowDetail) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);
	
					if (SONG.song.toLowerCase() == 'roses') {
						bgGirls.getScared();
					}
	
					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

				PixelSONG = true;
		    }
		    case 'thorns': {
		        curStage = 'schoolEvil';

		        var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		        var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		        var posX = 400;
	            var posY = 200;

		        var bg:FlxSprite = new FlxSprite(posX, posY);
		        bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
		        bg.animation.addByPrefix('idle', 'background 2', 24);
		        bg.animation.play('idle');
		        bg.scrollFactor.set(0.8, 0.9);
		        bg.scale.set(6, 6);
		        add(bg);

				PixelSONG = true;
		    }
			case 'guns' | 'stress' | 'ugh': {
				defaultCamZoom = 0.9;

				curStage = 'tank';

				var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tankSky', 'week7'));
				sky.scale.set(4, 9);
				add(sky);
				
				if (!Settings.LowDetail) {
					var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tankClouds'));
					clouds.scrollFactor.set(0.1, 0.1);
					clouds.velocity.x = FlxG.random.float(5, 15);
					add(clouds);
				}

				var mountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tankMountains', 'week7'));
				mountains.setGraphicSize(Std.int(mountains.width * 1.2));
				mountains.updateHitbox();
				mountains.scrollFactor.set(0.2, 0.2);
				add(mountains);

				if (!Settings.LowDetail) {
					var buildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankBuildings', 'week7'));
					buildings.setGraphicSize(Std.int(buildings.width * 1.1));
					buildings.updateHitbox();
					buildings.scrollFactor.set(0.3, 0.3);
					add(buildings);
	
					var ruins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankRuins', 'week7'));
					ruins.setGraphicSize(Std.int(buildings.width * 1.1));
					ruins.updateHitbox();
					ruins.scrollFactor.set(0.3, 0.3);
					add(ruins);
	
					smokeL = new FlxSprite(-200, -100);
					smokeL.frames = Paths.getSparrowAtlas('smokeLeft', 'week7');
					smokeL.animation.addByPrefix('smoke', 'SmokeBlurLeft', 24, true);
					smokeL.animation.play('smoke');
					smokeL.scrollFactor.set(0.4, 0.4);
					add(smokeL);
	
					smokeR = new FlxSprite(1100, -100);
					smokeR.frames = Paths.getSparrowAtlas('smokeRight', 'week7');
					smokeR.animation.addByPrefix('smoke', 'SmokeRight', 24, true);
					smokeR.animation.play('smoke');
					smokeR.scrollFactor.set(0.4, 0.4);
					add(smokeR);
	
					tankWatchtower = new FlxSprite(100, 50);
					tankWatchtower.frames = Paths.getSparrowAtlas('tankWatchtower', 'week7');
					tankWatchtower.animation.addByPrefix('watching', 'watchtower gradient color', 24, true);
					tankWatchtower.animation.play('watching');
					tankWatchtower.scrollFactor.set(0.5, 0.5);
					add(tankWatchtower);

				    tankGround = new FlxSprite(300, 350);
				    tankGround.frames = Paths.getSparrowAtlas('tankRolling', 'week7');
				    tankGround.animation.addByPrefix('tank', 'BG tank w lighting', 24, true);
				    tankGround.animation.play('tank');
					tankGround.scrollFactor.set(0.5, 0.5);
					add(tankGround);
				}

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);

				var ground:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tankGround', 'week7'));
				ground.setGraphicSize(Std.int(1.15 * ground.width));
				ground.updateHitbox();
				add(ground);

				if (!Settings.LowDetail) {
					tankdude1 = new FlxSprite(-500, 650);
					tankdude1.frames = Paths.getSparrowAtlas('tank0', 'week7');
					tankdude1.animation.addByPrefix('tank', 'fg tankhead far right instance 1', 24, true);
					tankdude1.animation.play('tank');
					tankdude1.scrollFactor.set(1.7, 1.5);
				
					tankdude2 = new FlxSprite(-300, 750);
					tankdude2.frames = Paths.getSparrowAtlas('tank1', 'week7');
					tankdude2.animation.addByPrefix('tank', 'fg tankhead 5 instance 1', 24, true);
					tankdude2.animation.play('tank');
					tankdude2.scrollFactor.set(2, 0.2);
				
					tankdude3 = new FlxSprite(450, 940);
					tankdude3.frames = Paths.getSparrowAtlas('tank2', 'week7');
					tankdude3.animation.addByPrefix('tank', 'foreground man 3 instance 1', 24, true);
					tankdude3.animation.play('tank');
					tankdude3.scrollFactor.set(1.5, 1.5);
				
					tankdude4 = new FlxSprite(1300, 900);
					tankdude4.frames = Paths.getSparrowAtlas('tank4', 'week7');
					tankdude4.animation.addByPrefix('tank', 'fg tankman bobbin 3 instance 1', 24, true);
					tankdude4.animation.play('tank');
					tankdude4.scrollFactor.set(1.5, 1.5);
				
					tankdude5 = new FlxSprite(1620, 700);
					tankdude5.frames = Paths.getSparrowAtlas('tank5', 'week7');
					tankdude5.animation.addByPrefix('tank', 'fg tankhead far right instance 1', 24, true);
					tankdude5.animation.play('tank');
					tankdude5.scrollFactor.set(1.5, 1.5);

					tankdude6 = new FlxSprite(1300, 1200);
					tankdude6.frames = Paths.getSparrowAtlas('tank3', 'week7');
					tankdude6.animation.addByPrefix('tank', 'fg tankhead 4 instance 1', 24, true);
					tankdude6.animation.play('tank');
					tankdude6.scrollFactor.set(3.5, 2.5);

					/*
					//image, library, x, y, scrollfactor x, scrollfactor y, screencenter, animated, xml code, loops
					var bg:BackgroundHelper = new BackgroundHelper('tank3', 'week7', 1300, 1200, 3.5, 2.5, false, true, 'fg tankhead 4 instance 1', true);
				    add(bg);
					//this doesn't work lol so uh ye
					*/
					
				}
				moveTank();
			}
			case 'ferocious': {
				defaultCamZoom = 0.6;

				curStage = 'garrett-school';

				schoolSTATIC = new FlxSprite(-1670, -600).loadGraphic(Paths.image('funnyAnimal/schoolBG', 'shared'));
				schoolSTATIC.scale.set(1.8, 1.8);
				schoolSTATIC.updateHitbox();
				add(schoolSTATIC);

				RUNBITCH = new FlxSprite(-200, 100);
				RUNBITCH.frames = Paths.getSparrowAtlas('funnyAnimal/runningThroughTheHalls', 'shared');
				RUNBITCH.animation.addByPrefix('run', 'Symbol 2', 60, true);
				RUNBITCH.animation.play('run');
				RUNBITCH.scale.set(1.8, 1.8);
				RUNBITCH.visible = false;
				add(RUNBITCH);

				RUNBITCHSTATIC = new FlxSprite(-200, 100);
				RUNBITCHSTATIC.frames = Paths.getSparrowAtlas('funnyAnimal/runningThroughTheHalls', 'shared');
				RUNBITCHSTATIC.animation.addByPrefix('run', 'Symbol 2', 60, false);
				RUNBITCHSTATIC.animation.play('run');
				RUNBITCHSTATIC.scale.set(1.8, 1.8);
				RUNBITCHSTATIC.visible = false;
				add(RUNBITCHSTATIC);

				BFLEGS2 = new FlxSprite(-460, 720);
				BFLEGS2.frames = Paths.getSparrowAtlas('funnyAnimal/leggi', 'shared');
				BFLEGS2.animation.addByPrefix('LEGS', 'poop attack0', 24, true);
				BFLEGS2.animation.addByPrefix('LEGSRUN', 'poop running down my leg', 24, true);
				BFLEGS2.animation.play('LEGSRUN');
				BFLEGS2.scale.set(0.7, 0.7);
				BFLEGS2.visible = false;
				add(BFLEGS2);

				blackScreenBG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blackScreenBG.scale.set(5, 5);
				blackScreenBG.visible = false;
				add(blackScreenBG);

				blackScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blackScreen.cameras = [camHUD];
				blackScreen.scale.set(5, 5);
				blackScreen.visible = false;
				add(blackScreen);

				Jail = new FlxSprite(0, 0).loadGraphic(Paths.image('funnyAnimal/jailCell', 'shared'));
				Jail.scale.set(1.8, 1.8);
				Jail.visible = false;
				Jail.screenCenter();
				Jail.updateHitbox();
				add(Jail);
			}
		    default:  {
		        defaultCamZoom = 0.9;
		        curStage = 'stage';

		        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		        bg.antialiasing = true;
		        bg.scrollFactor.set(0.9, 0.9);
		        bg.active = false;
		        add(bg);

		        var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		        stageFront.updateHitbox();
		        stageFront.antialiasing = true;
		        stageFront.scrollFactor.set(0.9, 0.9);
		        stageFront.active = false;
		        add(stageFront);

				if (!Settings.LowDetail) {
					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;
	
					add(stageCurtains);
				}
		    }

			#if !html5
			//this is for mods lolllll
			case songName: {
				if (stageMOD) {
				    trace('Loading mod stage...');
					//modSTAGE.add(modStageFILE); //trying to find a way for modstages to be loaded
					//var StageFILE:String = Assets.getText(Paths.MODtxt('stages/' + songName));
					trace('Loaded mod stage!');
				}
				else {
					trace('False alarm, There is no mod stage. \nLoading default stage...');
					defaultCamZoom = 0.9;
					curStage = 'stage';
	
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);
	
					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);
	
					if (!Settings.LowDetail) {
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
		
						add(stageCurtains);
					}
				}
			}
			//ok no more mods
			#end
        }

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				gfVersion = 'gf-tankmen';
			
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		if (SONG.song.toLowerCase() == 'stress')
			gfVersion = 'pico-speaker';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		if (gfVersion == 'pico-speaker')
		{
			gf.x -= 50;
			gf.y -= 200;
			var tankmen:TankmenBG = new TankmenBG(20, 500, true);
			tankmen.strumTime = 10;
			tankmen.resetShit(20, 600, true);
			tankmanRun.add(tankmen);
			for (i in 0...TankmenBG.animationNotes.length)
			{
				if (FlxG.random.bool(16))
				{
					var man:TankmenBG = tankmanRun.recycle(TankmenBG);
					man.strumTime = TankmenBG.animationNotes[i][0];
					man.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
					tankmanRun.add(man);
				}
			}
		}
	

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		dad = new Character(100, 100, SONG.player2);

		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player1) {
			case '3d-bf':
				boyfriend.x += 80;
				boyfriend.y -= 350;
				boyfriend.y += 320; //somehow this works lol
			case 'bf-holding-gf':
				boyfriend.y -= 15;
			default:
				trace('No X/Y adjustment for the player.');
		}

		switch (SONG.player2)
		{
			case 'garrett-animal':
				dad.x -= 430;
				dad.y -= 20;
			case 'dad':
				camPos.x += 400;
				OpponentHealthbar = 0xFF9271FD;
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn(1.3, (Conductor.stepCrochet * 4 / 1000));
				}
				OpponentHealthbar = 0xFF800080;
			case "spooky":
				dad.y += 200;
				OpponentHealthbar = 0xFFFFA500;
			case "monster":
				dad.y += 100;
				OpponentHealthbar = 0xFFFFA500;
			case 'monster-christmas':
				dad.y += 130;
				OpponentHealthbar = 0xFFFFA500;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
				OpponentHealthbar = 0xFF00FF00;
			case 'mom-car':
				OpponentHealthbar = 0xFFFC96D7;
			case 'parents-christmas':
				dad.x -= 500;
				OpponentHealthbar = 0xFF9271FD;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				OpponentHealthbar = 0xFFFF78BF;
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				OpponentHealthbar = 0xFFFF78BF;
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				OpponentHealthbar = 0xFFFF78BF;
			case "tankman":
				dad.y += 130;
				OpponentHealthbar = 0xFFF6B604;
			default:
				trace('No X/Y adjustment for the opponent.');
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'tank':
				gf.y += 10;
				gf.x -= 30;
				boyfriend.x += 40;
				boyfriend.y += 0;
				dad.y += 60;
				dad.x -= 80;
				if (gfVersion != 'pico-speaker')
				{
					gf.x -= 170;
					gf.y -= 75;
				}
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'garrett-school') {
			gf.visible = false;
			add(dad);
			add(boyfriend);
		}
		else if (curStage == 'tank' && !Settings.LowDetail) {
			add(dad);
			add(boyfriend);

			add(tankdude1);
			add(tankdude2);
			add(tankdude3);
			add(tankdude4);
			add(tankdude5);
			add(tankdude6);
		}
		else if (curStage == 'limo') {
			add(limo);

			add(dad);
			add(boyfriend);
		}
		else {
			add(dad);
			add(boyfriend);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = DialogueEnd;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		opponentStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(OpponentHealthbar, BFHealthbar);
		// healthBar
		add(healthBar);

		trace(SONG.song);
		songTxt = new FlxText(0, healthBarBG.y -60, 400, "", 24);
		if (PixelSONG) {
			songTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			songTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		songTxt.borderSize = 3;
		songTxt.scrollFactor.set();
		add(songTxt);

		missesTxt = new FlxText(0, healthBarBG.y -30, 400, "", 24);
		if (PixelSONG) {
			missesTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			missesTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		missesTxt.borderSize = 3;
		missesTxt.scrollFactor.set();
		add(missesTxt);

		scoreTxt = new FlxText(0, healthBarBG.y, 400, "", 24);
		if (PixelSONG) {
			scoreTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			scoreTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		scoreTxt.borderSize = 3;
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		ratingTxt = new FlxText(0, healthBarBG.y +30, 400, "", 24);
		if (PixelSONG) {
			ratingTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			ratingTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		ratingTxt.borderSize = 3;
		ratingTxt.scrollFactor.set();
		add(ratingTxt);

		if (Settings.Downscroll) {
			missesTxt.y -= 600;
			scoreTxt.y -= 600;
			ratingTxt.y -= 600;
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		missesTxt.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		ratingTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		/*
		if (halloweenLevel) {
			var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			add(blackScreen);
			blackScreen.alpha = 0.6;
			blackScreen.cameras = [camHUD];
			blackScreen.scrollFactor.set();
		}
		*/

		function playCutscene(name:String, atEndOfSong:Bool = false, ?isCutscene:Bool = true)
		{
			var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			blackScreen.cameras = [camHUD];
			add(blackScreen);
			blackScreen.scrollFactor.set();
			
			inCutscene = true;
			this.inCutscene = isCutscene;
			FlxG.sound.music.stop();
			
			#if !html5
			var video:VideoHandler = new VideoHandler();
			video.finishCallback = function()
			{
				FlxTween.tween(blackScreen, {alpha: 0}, 1);

				// patch for mid-song videos
				if (isCutscene && songStarted)
				{
					persistentUpdate = false;
					persistentDraw = true;
					paused = true;
				}

				if (atEndOfSong)
				{
					if (storyPlaylist.length <= 0)
						FlxG.switchState(new StoryMenuState());
					else
					{
						SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
						FlxG.switchState(new PlayState());
					}
				}
				else {
					startCountdown();
				}
			}
			video.playVideo(Paths.video(name));
			#else
			new FlxVideo('videos/' + name).finishCallback = function()
			{
				FlxTween.tween(blackScreen, {alpha: 0}, 1);

				if (atEndOfSong)
				{
					if (storyPlaylist.length <= 0)
						FlxG.switchState(new StoryMenuState());
					else
					{
						SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
						FlxG.switchState(new PlayState());
					}
				}
				else {
					startCountdown();
				}
			};
			#end
		}

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case 'tutorial':
					startDialogue(doof);
				case 'bopeebo':
					startDialogue(doof);
				case 'fresh':
					startDialogue(doof);
				case 'dadbattle':
					startDialogue(doof);
				case 'spookeez':
					startDialogue(doof);
				case 'south':
					startDialogue(doof);
				case 'monster':
					startDialogue(doof);
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'ugh':
					playCutscene('ughCutscene.mp4', false);
				case 'guns':
					playCutscene('gunsCutscene.mp4', false);
				case 'stress':
					playCutscene('stressCutscene.mp4', false);
				default:
					startCountdown();
			}
		}
		else 
		{
			switch (curSong.toLowerCase()) 
		    {
				case 'ferocious':
					var greenScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.GREEN);
					greenScreen.scale.set(5, 5);
					greenScreen.cameras = [camHUD];
					add(greenScreen);

					var Garrett:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('funnyAnimal/fat_guy', 'shared'));
					Garrett.cameras = [camHUD];
					Garrett.screenCenter();
					Garrett.updateHitbox();
					add(Garrett);

					var CanYou:FlxSprite = new FlxSprite(250, 450).loadGraphic(Paths.image('funnyAnimal/canYouBeat', 'shared'));
					CanYou.cameras = [camHUD];
					CanYou.updateHitbox();
					add(CanYou);

					new FlxTimer().start(6, function(tmr:FlxTimer) 
					{
						remove(Garrett);
						var Garrett:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('funnyAnimal/obese_guy', 'shared'));
						Garrett.cameras = [camHUD];
						Garrett.screenCenter();
						Garrett.updateHitbox();
						add(Garrett);

						remove(CanYou);
						var CanYou:FlxSprite = new FlxSprite(250, 450).loadGraphic(Paths.image('funnyAnimal/hooray', 'shared'));
						CanYou.cameras = [camHUD];
						CanYou.updateHitbox();
						add(CanYou);

						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							remove(greenScreen);
							remove(Garrett);
							remove(CanYou);
							startCountdown();
						});
					});
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function startDialogue(?dialogueBox:DialogueBox) {
		if (dialogueBox != null) {
			trace('Started dialogue!');
			inCutscene = true;
			add(dialogueBox);
		}
		else {
			trace('Ending dialogue!');
			DialogueEnd();
		}
	}

	function DialogueEnd() {
		inCutscene = false;
		startCountdown();
		trace('Ended dialogue!');
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					DialogueEnd();

				remove(black);
			}
		});
	}

	function ReloadIcons() {
		remove(iconP1);
		iconP1 = new HealthIcon(boyfriend.curCharacter, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);
		iconP1.cameras = [camHUD];

		remove(iconP2);
		iconP2 = new HealthIcon(dad.curCharacter, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		iconP2.cameras = [camHUD];
	}

	function PlayANIMATION(Player:Int, AnimName:Dynamic) {
		if (Player == 3){
			gf.playAnim(AnimName, true);
		}
		else if (Player == 2) {
			dad.playAnim(AnimName, true);
		}
		else if (Player == 1) {
			boyfriend.playAnim(AnimName, true);
		}
	}

	function ChangeCHAR(Player:Int, X:Dynamic, Y:Dynamic, NewCHAR:Dynamic) {
		if (Player == 3){
			gf.alpha = 0.0000001;
			remove(gf);
			gf = new Character(X, Y, NewCHAR);
			add(gf);
		}
		else if (Player == 2) {
			dad.alpha = 0.0000001;
			remove(dad);
			dad = new Character(X, Y, NewCHAR);
			add(dad);
		}
		else if (Player == 1) {
			boyfriend.alpha = 0.0000001;
			remove(boyfriend);
			boyfriend = new Boyfriend(X, Y, NewCHAR);
			add(boyfriend);
		}
		ReloadIcons();
		FlxG.camera.flash(FlxColor.WHITE, 0.35, null, true);
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown(?dialogueBox:DialogueBox):Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	public function startSong():Void
	{
		startingSong = false;
		songStarted = true;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);

			babyArrow = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					if (curStage != 'garrett-school') {
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					}
					else if (curStage == 'garrett-school') {
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets_3D');
					}
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (Settings.Downscroll) {
				babyArrow.y += 500;
			}

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}

			if (player == 0) {
				opponentStrums.add(babyArrow);
			}
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCam(zoom:Float, time:Float):Void
	{
		FlxTween.tween(FlxG.camera, {zoom: zoom}, time, {type: FlxTween.PERSIST});
	}

	function tweenCamIn(zoom:Float, time:Float):Void
	{
		FlxTween.tween(FlxG.camera, {zoom: zoom}, time, {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	var tankX:Float = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if(!inCutscene && !Settings.LowDetail)
		{
			tankAngle += elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'tank':
				moveTank(elapsed);
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		/*
		var spam:Bool = false;
		if (tankmanHEAVEN && SONG.song == 'guns' && !spam) {
			spam = true;
			FlxTween.tween(camFollow, {y: -2500}, 13, {
				onComplete:function(twn:FlxTween)
				{
					//return down!!!!
					FlxTween.tween(camFollow, {y: 0}, 8);
				}
			});
		}
		*/

		super.update(elapsed);

		songTxt.text = "" + SONG.song;
		missesTxt.text = "Combo Breaks:" + misses;
		scoreTxt.text = "Score:" + songScore;
		if (misses == 0) {
			ratingTxt.text = "FC";
		}
		else {
			ratingTxt.text = "Clear";
		}

		//DiscordClient.changePresence(detailsText, SONG.song + " ("  +scoreTxt + " - " +ratingTxt +")", iconRPC);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20) {
			iconP1.animation.curAnim.curFrame = 1;
		}
		else {
			iconP1.animation.curAnim.curFrame = 0;
		}

		if (iconP1.angle == 25) {
			iconP1.angle == -25;
		}
		else if (iconP1.angle == -25) {
			iconP1.angle == 25;
		}

		if (iconP2.angle == 25) {
			iconP2.angle == -25;
		}
		else if (iconP2.angle == -25) {
			iconP2.angle == 25;
		}

		if (healthBar.percent > 80) {
			iconP2.animation.curAnim.curFrame = 1;
		    //iconP1.animation.curAnim.curFrame = 3; //working winning icon for bf!!!!! but uh it looks bad (my drawing) so im not gonna include it lol
		}
		else {
			iconP2.animation.curAnim.curFrame = 0;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'playtime':
						camFollow.x = dad.getMidpoint().x -300;
						camFollow.y = dad.getMidpoint().y -300;
				    case 'garrett-ipad':
						camFollow.x = dad.getMidpoint().x +350;
						camFollow.y = dad.getMidpoint().y -150;
					case 'pedophile':
						camFollow.x = dad.getMidpoint().x +50;
						camFollow.y = dad.getMidpoint().y -100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn(1.3, (Conductor.stepCrochet * 4 / 1000));
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (boyfriend.curCharacter) {
					case 'bf-ipad':
						camFollow.x = dad.getMidpoint().x +350;
						camFollow.y = dad.getMidpoint().y -150;
				}

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		if (health <= 0 && !practiceMode)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			deathCounter += 1;

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						combo = 0; //you lose your combo and miss when you don't click a note lol
						misses += 1;
						health -= 0.0475;
						vocals.volume = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function UnlockWeek() {
		if (storyWeek == 1) {
			Settings.Week2Unlocked = true;
		}

		if (storyWeek == 2) {
			Settings.Week3Unlocked = true;
		}

		if (storyWeek == 3) {
			Settings.Week4Unlocked = true;
		}

		if (storyWeek == 4) {
			Settings.Week5Unlocked = true;
		}

		if (storyWeek == 5) {
			Settings.Week6Unlocked = true;
		}

		if (storyWeek == 6) {
			Settings.Week7Unlocked = true;
		}
		Settings.SettingsSave();
	}

	function endSong():Void
	{
		deathCounter = 0;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				if (storyWeek == 0) {
					trace('already unlocked lol');
				}
				else {
					UnlockWeek();
				}

				FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;
	
	/*
	override public function onFocus()
	{
		super.onFocus();
		FlxG.sound.music.resume();
		trace("[SYSTEM] User Focused the window");
	}
		
	override public function onFocusLost()
	{
		super.onFocusLost();
		FlxG.sound.music.pause();
		trace("[SYSTEM] User Lost Focus the window");
	}
	*/
	
	//this fucks up paused music

	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = "shit";
			score = 75;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = "bad";
			score = 160;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = "good";
			score = 350;
		}
		else {
			daRating = "sick";
			SpawnNoteSplash(note);
			score = 450;
		}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (SONG.song == 'Ferocious') {
			pixelShitPart1 == "3dUI/";
			pixelShitPart2 == '-3d';
		}

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x -360;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.cameras = [camHUD];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x -320;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		comboSpr.cameras = [camHUD];
		if (combo >= 10 && !week7zoom) {
			add(comboSpr);
		}
		
		if (!week7zoom) {
			add(rating);			
		}

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) -360;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.cameras = [camHUD];

			if (combo >= 10 || combo == 0) {
				if (!week7zoom) {
					add(numScore);
				}
			}

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		daRating = '';
		score = 0;

		curSection += 1;
	}

	function SpawnNoteSplash(note:Note):Void
    {
		var notesplash:FlxSprite;
		notesplash = new FlxSprite(0, 0);
		notesplash.frames = Paths.getSparrowAtlas('noteSplashes', 'shared');
		notesplash.animation.addByPrefix('note1-0', 'note impact 1  blue', 24, false);
		notesplash.animation.addByPrefix('note1-1', 'note impact 2 blue', 24, false);
		notesplash.animation.addByPrefix('note2-0', 'note impact 1 green', 24, false);
		notesplash.animation.addByPrefix('note2-1', 'note impact 2 green', 24, false);
		notesplash.animation.addByPrefix('note0-0', 'note impact 1 purple', 24, false);
		notesplash.animation.addByPrefix('note0-1', 'note impact 2 purple', 24, false);
		notesplash.animation.addByPrefix('note3-0', 'note impact 1 red', 24, false);
		notesplash.animation.addByPrefix('note3-1', 'note impact 2 red', 24, false);
		notesplash.cameras = [camHUD];
		notesplash.scale.set(0.85, 0.85);

		notesplash.x = 615;
		notesplash.y = -50;

		switch (note.noteData) {
			case 0:
				notesplash.animation.play('note0-' + FlxG.random.int(0, 1), true);
			case 1:
				notesplash.x += 100;
				notesplash.animation.play('note1-' + FlxG.random.int(0, 1), true);
			case 2:
				notesplash.x += 225;
				notesplash.animation.play('note2-' + FlxG.random.int(0, 1), true);
			case 3:
				notesplash.x += 350;
				notesplash.animation.play('note3-' + FlxG.random.int(0, 1), true);
		}
		add(notesplash);

		FlxTween.tween(notesplash, {alpha: 0}, 0.35, {
			onComplete: function(tween:FlxTween)
			{
				if (Settings.Cache) {
					notesplash.destroy();
				}
			},
		});

		/*
		if (notesplash.animation.curAnim.finished) {
			notesplash.alpha = 0.00000000000000000000000000000000000000000000000000000000001;
		}
		*/
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			if (Settings.RobloxFnFAnimation) {
				if (leftP) {
					boyfriend.playAnim('singLEFT', true);
				}

				if (downP) {
					boyfriend.playAnim('singDOWN', true);
				}

				if (upP) {
					boyfriend.playAnim('singUP', true);
				}

				if (rightP) {
					boyfriend.playAnim('singRIGHT', true);
				}
			}

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
			}
			else
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned && !Settings.GhostTapping)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses += 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				combo += 1;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	#if !html5
	function getModStage():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.MODtxt('stages/' + songName));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];
	
		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}
	
		return swagGoodArray;
	}
	#end

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var CAMGOINGUP:FlxTween;
	//Cam zoom, alpha for camHUD, if tankman floats in guns
	function TankmanSHITS(CAMZOOM:Bool, ?ALPHA:Float = 1, ?gunsFLOAT:Bool = false) {
		if (CAMZOOM) {
			week7zoom = true;

			camFollow.x = 225;
			FlxTween.tween(FlxG.camera, {zoom: 1.25}, 0.35);
			FlxG.camera.focusOn(camFollow.getPosition());
		}
		else {
			week7zoom = false;
			
			camFollow.x = 0;
			camFollow.y = 0;
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.35);
		}
		FlxTween.tween(camHUD, {alpha: ALPHA}, 0.35);

		if (gunsFLOAT) {
			FlxTween.tween(camHUD, {y: 1000}, 0.35);
			CAMGOINGUP = FlxTween.tween(camFollow, {y: -2500}, 13);
			
			FlxTween.tween(dad, {y: -2500}, 12, {
				onComplete:function(twn:FlxTween)
				{
					//230 is tankmans position but its not the same previously
					FlxTween.tween(dad, {y: 285}, 8);
				}
			});
			trace('TANKMAN IS FLOATING!!!!!!');
		}
		else {
			//tankmanHEAVEN = false;
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.35);
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		if (SONG.song.toLowerCase() == 'guns') {
			if (curStep == 896) {
				TankmanSHITS(true, 0, true);

				trace('zoom lol');
			}

			if (curStep == 1022) {
				TankmanSHITS(false, 1, false);
				FlxTween.tween(camHUD, {y: 0}, 0.8);

				CAMGOINGUP.cancel();
				//FlxTween.tween(camFollow, {y: 650}, 2.3);
				FlxTween.tween(camFollow, {y: boyfriend.getMidpoint().y - 100}, 2.3);

				trace('No more zoom :(');
			}
		}

		if (SONG.song.toLowerCase() == 'stress') {
			if (curStep == 736) {
				TankmanSHITS(true, 0.4);

				trace('Changing alpha to make more cool');
			}

			if (curStep == 768) {
				TankmanSHITS(false, 1);

				trace('Changing alpha back to normal for strums...');
			}
		}

		if (SONG.song.toLowerCase() == 'ferocious') {
			if (curStep == 12) {
				trace('THIS IS FOR TESTING LOL');
			}

			if (curStep == 1152) {
				ChangeCHAR(2, -110, 220, 'playtime');
				PlayANIMATION(2, 'garrett pulls out ass');
				trace('garret summoned playtime out of ass');
			}

			if (curStep == 2159) {
				RUNBITCH.visible = true;
				BFLEGS2.visible = true;
				defaultCamZoom = 0.75;
				ChangeCHAR(2, 840, 840, 'palooseMen');
				camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
				ChangeCHAR(1, -230, 625, '3d-bf-flipped');

				trace('POLICE IS ON YOUR ASS RUN BITCH');
			}

			if (curStep == 3215) {
				defaultCamZoom = 0.7;
				RUNBITCH.visible = false;
				BFLEGS2.visible = false;
				Jail.visible = true;

				var whereTonowlol:Float = dad.x +3800;

				ChangeCHAR(2, 680, 620, 'palooseMen');
				ChangeCHAR(1, 1340, 1020, '3d-bf');

				FlxTween.tween(dad, {x: whereTonowlol}, 6.5, {
					startDelay: 1.45, 
					onComplete: function(twn:FlxTween) 
					{
						//dad.visible = false;
						//this broke it lol
					}
				});
			}

			if (curStep == 3311) {
				defaultCamZoom = 0.5;
				Jail.visible = false;

				/*
				IPADBG = new FlxSprite(FlxG.width -1800, FlxG.height -1150).loadGraphic(Paths.image('funnyAnimal/futurePadBG', 'shared'));
				IPADBG.visible = true;
				IPADBG.scale.set(2, 2);
				IPADBG.updateHitbox();
				add(IPADBG);
				*/

				ChangeCHAR(2, -190, 300, 'garrett-ipad');
				ChangeCHAR(1, 200, -150, 'bf-ipad');

				blackScreenBG.visible = true;
				IPAD = new FlxSprite(FlxG.width -1800, FlxG.height -1150).loadGraphic(Paths.image('funnyAnimal/futurePad', 'shared'));
				IPAD.scale.set(2, 2);
				IPAD.updateHitbox();
				add(IPAD);
				trace('GARRETT IS PISSED LOL');
			}

			if (curStep == 4719) {
				defaultCamZoom = 0.8;
				blackScreenBG.visible = false;
				IPAD.visible = false;
				RUNBITCHSTATIC.visible = true;
				ChangeCHAR(2, -370, 240, 'wizard');
				ChangeCHAR(1, 770, 875, '3d-bf');
				trace('wizard!!!');
			}

			if (curStep == 5903) {
				RUNBITCHSTATIC.visible = false;
				RUNBITCH.visible = true;
				var offsets:Float = boyfriend.x -580;
				ChangeCHAR(2, offsets, 500, 'piano-guy');
				ChangeCHAR(1, 770, 900, '3d-bf-flipped');
				trace('piano guy?');
			}

			if (curStep == 7719) {
				RUNBITCHSTATIC.visible = true;
				RUNBITCH.visible = false;

				var whereTonowlol:Float = dad.x -3800;
				var offsets:Float = boyfriend.x +400;
				FlxTween.tween(dad, {x: whereTonowlol}, 1.3, {
					onComplete: function(twn:FlxTween) 
					{
						ChangeCHAR(2, offsets, 320, 'pedophile');
						trace('OH NO ITS A PEDOPHILE RUN BITCH');
					}
				});
			}

			if (curStep == 8703) {
				PEDOPHILESTATIC = new FlxSprite(dad.x, dad.y);
				PEDOPHILESTATIC.frames = Paths.getSparrowAtlas('funnyAnimal/zunkity', 'shared');
				PEDOPHILESTATIC.animation.addByPrefix('hey its the toddler', 'FAKE LOADING SCREEN0000', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('hhmm', 'FAKE LOADING SCREEN0001', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('smile', 'FAKE LOADING SCREEN0002', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('im smile at you', 'FAKE LOADING SCREEN0003', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('you ugly', 'FAKE LOADING SCREEN0004', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('did you get uglier', 'FAKE LOADING SCREEN0005', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('garrett is ugly', 'FAKE LOADING SCREEN0006', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('bf is ugly', 'FAKE LOADING SCREEN0007', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('like my cut', 'FAKE LOADING SCREEN0008', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('i wear a mask with a smile', 'FAKE LOADING SCREEN0009', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('wtf', 'FAKE LOADING SCREEN0010', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('THERE IS A CAR COMING RUN BITCH', 'FAKE LOADING SCREEN0011', 24, false);
				PEDOPHILESTATIC.animation.play('hey its the toddler');
				PEDOPHILESTATIC.visible = false;
				add(PEDOPHILESTATIC);

				ChangeCHAR(2, -370, 420, 'garrett-angry');
				ChangeCHAR(1, 770, 875, '3d-bf');

				PEDOPHILESTATIC.animation.play('hey its the toddler');
				PEDOPHILESTATIC.visible = true;
			}
		}

		if (curStep == 8927) {
			PEDOPHILESTATIC.animation.play('hhmm');
		}

		if (curStep == 9119) {
			PEDOPHILESTATIC.animation.play('smile');
		}

		if (curStep == 9279) {
			PEDOPHILESTATIC.animation.play('im smile at you');
		}

		if (curStep == 9347) {
			PEDOPHILESTATIC.animation.play('you ugly');
		}

		if (curStep == 9420) {
			PEDOPHILESTATIC.animation.play('did you get uglier');
		}

		if (curStep == 9503) {
			PEDOPHILESTATIC.animation.play('garrett is ugly');
		}

		if (curStep == 9759) {
			PEDOPHILESTATIC.animation.play('bf is ugly');
		}

		if (curStep == 10015) {
			PEDOPHILESTATIC.animation.play('like my cut');
		}

		if (curStep == 10527) {
			PEDOPHILESTATIC.animation.play('wtf');
		}

		if (curStep == 10863) {
			PEDOPHILESTATIC.animation.play('THERE IS A CAR COMING RUN BITCH');
		}

		if (curStep == 11035) {
			PEDOPHILESTATIC.visible = false;
			blackScreen.visible = true;
			RUNBITCHSTATIC.visible = false;
			RUNBITCH.visible = true;
			BFLEGS2.visible = true;
			BFLEGS2.x += 1340;
			ChangeCHAR(1, 1130, 625, '3d-bf');
			ChangeCHAR(2, -230, 425, 'garrett-car');

			POLICECAR = new FlxSprite(dad.x, dad.y);
			POLICECAR.frames = Paths.getSparrowAtlas('funnyAnimal/palooseCar', 'shared');
			POLICECAR.animation.addByPrefix('run', 'idle0', 24, true);
			POLICECAR.animation.play('run');
			add(POLICECAR);

			new FlxTimer().start(0.6, function(tmr:FlxTimer) {
				blackScreen.visible = false;
			});
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				if (!Settings.LowDetail) {
					bgGirls.dance();
				}

			case 'mall':
				if (!Settings.LowDetail) {
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if (!Settings.LowDetail) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
		
					if (FlxG.random.bool(10) && fastCarCanDrive)
						fastCarDrive();
				}
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					if (!Settings.LowDetail) {
					    phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
					    });

					    curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					    phillyCityLights.members[curLight].visible = true;
					    // phillyCityLights.members[curLight].alpha = 1;
				    }
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					if (!Settings.LowDetail) {
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	public function CacheIMAGE(graphic:Dynamic, ?sharedFolder:Bool = false)
	{
		if (!sharedFolder) {
			var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
			newthing.visible = false;
			add(newthing);
			remove(newthing);

			//AssetCache('IMAGE', Paths.image(graphic)); //this isn't valid or something
			trace('Cached image in normal folder: ' + graphic);
		}
		else if (sharedFolder) {
			var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic, 'shared'));
			newthing.visible = false;
			add(newthing);
			remove(newthing);

			//AssetCache('IMAGE', Paths.image(graphic, 'shared')); //this isn't valid or something
			trace('Cached image in shared folder: ' + graphic);
		}
	}

	var curLight:Int = 0;
}