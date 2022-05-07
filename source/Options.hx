package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;

class OptionCategory
{
	private var _options:Array<Option> = [];

	public function new(catName:String, ?options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}

	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";

	public final function getName()
	{
		return _name;
	}
}

class Option
{
	private var display:String;
	private var acceptValues:Bool = false;

	public var isBool:Bool = true;
	public var daValue:Bool = false;

	public function new()
	{
		display = updateDisplay();
	}

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return true;
	}

	private function updateDisplay():String
	{
		return "";
	}

	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}
}

class FPSOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.fps;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		daValue = FlxG.save.data.fps;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter";
	}
}

class MEMOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.mem;
	}

	public override function press():Bool
	{
		FlxG.save.data.mem = !FlxG.save.data.mem;
		(cast(Lib.current.getChildAt(0), Main)).toggleMem(FlxG.save.data.mem);
		daValue = FlxG.save.data.mem;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Memory Info";
	}
}

class VerOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.v;
	}

	public override function press():Bool
	{
		FlxG.save.data.v = !FlxG.save.data.v;
		(cast(Lib.current.getChildAt(0), Main)).toggleVers(FlxG.save.data.v);
		daValue = FlxG.save.data.v;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Version Display";
	}
}

class DownscrollOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.downscroll;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		daValue = FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll";
	}
}

class BotplayOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.botplay;
	}

	public override function press():Bool
	{
		FlxG.save.data.botplay = !FlxG.save.data.botplay;
		daValue = FlxG.save.data.botplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Botplay";
	}
}

class TimebarOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.showTimeBar;
	}

	public override function press():Bool
	{
		FlxG.save.data.showTimeBar = !FlxG.save.data.showTimeBar;
		daValue = FlxG.save.data.showTimeBar;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "TimeBar";
	}
}

class NoteSplashOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.noteSplashes;
	}

	public override function press():Bool
	{
		FlxG.save.data.noteSplashes = !FlxG.save.data.noteSplashes;
		daValue = FlxG.save.data.noteSplashes;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NoteSplash";
	}
}

class RatingOption extends Option
{
	public function new()
	{
		super();
		daValue = FlxG.save.data.ratingCntr;
	}

	public override function press():Bool
	{
		FlxG.save.data.ratingCntr = !FlxG.save.data.ratingCntr;
		daValue = FlxG.save.data.ratingCntr;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Rating Counter";
	}
}
