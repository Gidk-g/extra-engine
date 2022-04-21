package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.FileSystem;
#end

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;

	public var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon()
	{
		if (isOldIcon = !isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon('bf');
	}

	public function changeIcon(char:String)
	{
		if (this.char != char)
		{
			var name:String = 'icons/icon-' + char;
			if (!FileSystem.exists('images/' + name + '.png'))
				name = 'icons/icon-' + char;

			var file:Dynamic = Paths.image(name);

			loadGraphic(file, true, 150, 150);
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			if (char.endsWith('-pixel') || char.startsWith('senpai') || char.startsWith('spirit'))
			{
				antialiasing = false;
			}
			else
			{
				antialiasing = true;
			}
		}
	}

	public function getCharacter():String
	{
		return char;
	}
}
