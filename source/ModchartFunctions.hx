package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class ModchartFunctions
{
	public static var curSprites:Map<String, FlxSprite> = new Map<String, FlxSprite>();

	public static function addCustomSprite(tag:String, behindCharacters:Bool = false) {}

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public static function changeDad(newDad:String, positionProperly:Bool = false)
	{
		var oldDad = dad;
		PlayState.instance.removeObject(dad);
		dad = new Character(oldDad.x, oldDad.y, newDad);
		PlayState.instance.addObject(dad);

		if (positionProperly)
		{
			dad.x = oldDad.x + (oldDad.width / 2) - (dad.width / 2);
	        dad.y = oldDad.y + oldDad.height - dad.height;
		}
	}

	public static function changeBoyfriend(newBf:String, positionProperly:Bool = false)
	{
		var oldBf = boyfriend;
		PlayState.instance.removeObject(boyfriend);
	    boyfriend = new Boyfriend(oldBf.x, oldBf.y, newBf);
		PlayState.instance.addObject(boyfriend);

		if (positionProperly)
		{
			boyfriend.x = oldBf.x + (oldBf.width / 2) - (boyfriend.width / 2);
			boyfriend.y = oldBf.y + oldBf.height - boyfriend.height;
		}
	}

	public static function changeGirlfriend(newGf:String, positionProperly:Bool = false)
	{
		var oldGf = gf;
		PlayState.instance.removeObject(gf);
		dad = new Character(oldGf.x, oldGf.y, newGf);
		PlayState.instance.addObject(gf);

		if (positionProperly)
		{
			dad.x = oldGf.x + (oldGf.width / 2) - (gf.width / 2);
			dad.y = oldGf.y + oldGf.height - gf.height;
		}
	}
}
