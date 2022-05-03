package;

import openfl.text.TextFormat;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = StartState; // The FlxState the game starts with.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		// quick checks

		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if html5
		framerate = 60;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		display = new SimpleInfoDisplay(10, 3, 0xFFFFFF);
		addChild(display);
		#end

		if (FlxG.save.data.fps != null)
			(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);

		if (FlxG.save.data.mem != null)
			(cast(Lib.current.getChildAt(0), Main)).toggleMem(FlxG.save.data.mem);

		if (FlxG.save.data.v != null)
			(cast(Lib.current.getChildAt(0), Main)).toggleVers(FlxG.save.data.v);

		FlxG.mouse.visible = false;
	}

	public static var display:SimpleInfoDisplay;

	public function toggleFPS(enabled:Bool):Void
	{
		display.infoDisplayed[0] = enabled;
	}

	public function toggleMem(enabled:Bool):Void
	{
		display.infoDisplayed[1] = enabled;
	}

	public function toggleVers(enabled:Bool):Void
	{
		display.infoDisplayed[2] = enabled;
	}

	public static function changeFont(font:String):Void
	{
		display.defaultTextFormat = new TextFormat(font, (font == "_sans" ? 12 : 14), display.textColor);
	}
}
