package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.graphics.FlxGraphic;

class Prefs {
	public static var globalAntialiasing:Bool = true;

	public static function saveSettings() {
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
	}

	public static function loadPrefs() {
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.Antialiasing;
		}
	}

	public static function init()
	{
		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;

		if (FlxG.save.data.mem == null)
			FlxG.save.data.mem = true;

		if (FlxG.save.data.v == null)
			FlxG.save.data.v = true;

		if (FlxG.save.data.showTimeBar == null)
			FlxG.save.data.showTimeBar = true;

		if (FlxG.save.data.noteSplashes == null)
			FlxG.save.data.showTimeBar = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
	}
}