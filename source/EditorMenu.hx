package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.input.gamepad.FlxGamepad;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.utils.Assets;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class EditorMenu extends MusicBeatState
{
	var optionShit:Array<String> = ['Chart Editor','Animation Editor'];

	var confirming:Bool = false;

	static var curSelected:Int = 0;

	private var grpOptionShit:FlxTypedGroup<Alphabet>;

	var bg:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFF353535;
		add(bg);

		grpOptionShit = new FlxTypedGroup<Alphabet>();
		add(grpOptionShit);

		for (i in 0...optionShit.length)
		{
			var creditText:Alphabet = new Alphabet(0, (70 * i) + 30, optionShit[i], true, false);
			creditText.isMenuItem = true;
			creditText.targetY = i;
			grpOptionShit.add(creditText);

			// creditText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// creditText.screenCenter(X);
		}

		changeSelection();
		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);

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

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (upP && !confirming)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(-shiftMult);
		}
		if (downP && !confirming)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSelection(shiftMult);
		}

		if (controls.BACK && !confirming)
			FlxG.switchState(new MainMenuState());

		if (controls.ACCEPT && !confirming)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			confirming = true;
			FlxFlicker.flicker(grpOptionShit.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
			{
				switch (optionShit[curSelected])
				{
					case 'Chart Editor':
						LoadingState.loadAndSwitchState(new ChartingState(), false);
					case 'Animation Editor':
						LoadingState.loadAndSwitchState(new AnimationEditor());
				}
				FlxG.sound.music.volume = 0;
				confirming = false;
			});
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = optionShit.length - 1;
		if (curSelected >= optionShit.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;
		var bullShit:Int = 0;

		for (item in grpOptionShit.members)
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
