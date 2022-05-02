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
}