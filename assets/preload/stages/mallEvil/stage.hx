function createBackground()
{
    // This happens BEFORE BF and GF get put.

    var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.2, 0.2);
    bg.active = false;
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.updateHitbox();
    add(bg);

    var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
    evilTree.antialiasing = true;
    evilTree.scrollFactor.set(0.2, 0.2);
    add(evilTree);

    var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
    evilSnow.antialiasing = true;
    add(evilSnow);
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