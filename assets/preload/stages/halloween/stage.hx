var halloweenBG:FlxSprite;
var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function createBackground()
{
    // This happens BEFORE BF and GF get put.

    var hallowTex = Paths.getSparrowAtlas('halloween_bg');

    halloweenBG = new FlxSprite(-200, -100);
    halloweenBG.frames = hallowTex;
    halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
    halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
    halloweenBG.animation.play('idle');
    halloweenBG.antialiasing = true;
    add(halloweenBG);
}

function createForeground(bf:Character, gf:Character, dad:Character)
{
    // This happens AFTER BF and GF get put.
    // Meaning sprites created here will be put INFRONT of the characters

    // bf is Boyfriend/Player 1/Player
    // gf is, well, Girlfriend
    // dad is Dad/Player 2/Enemy
}

function beatHit(curBeat:Int)
{
    // This happens when a beat is hit.
    // Useful for things like Philly lights, etc.

    if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
    {
        lightningStrikeShit();
    }
}

function stepHit(curStep:Int)
{
    // This happens when a step (1/4th of a beat) is hit.
    // I don't actually know what this is useful for
}

function onUpdate(elapsed:Float)
{
    // This happens every frame.
    // Useful for checking key presses, and other things
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