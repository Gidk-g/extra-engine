function createBackground()
{
    // This happens BEFORE BF and GF get put.

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
}

function createForeground(bf:Character, gf:Character, dad:Character)
{
    // This happens AFTER BF and GF get put.
    // Meaning sprites created here will be put INFRONT of the characters

    // bf is Boyfriend/Player 1/Player
    // gf is, well, Girlfriend
    // dad is Dad/Player 2/Enemy

    var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
    stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
    stageCurtains.updateHitbox();
    stageCurtains.antialiasing = true;
    stageCurtains.scrollFactor.set(1.3, 1.3);
    stageCurtains.active = false;
    add(stageCurtains);
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