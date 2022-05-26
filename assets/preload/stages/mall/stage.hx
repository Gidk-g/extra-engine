var upperBoppers:FlxSprite;
var bottomBoppers:FlxSprite;
var santa:FlxSprite;

function createBackground()
{
    // This happens BEFORE BF and GF get put.

    var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.2, 0.2);
    bg.active = false;
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.updateHitbox();
    add(bg);

    upperBoppers = new FlxSprite(-240, -90);
    upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
    upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
    upperBoppers.antialiasing = true;
    upperBoppers.scrollFactor.set(0.33, 0.33);
    upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
    upperBoppers.updateHitbox();
    add(upperBoppers);


    var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
    bgEscalator.antialiasing = true;
    bgEscalator.scrollFactor.set(0.3, 0.3);
    bgEscalator.active = false;
    bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
    bgEscalator.updateHitbox();
    add(bgEscalator);

    var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
    tree.antialiasing = true;
    tree.scrollFactor.set(0.40, 0.40);
    add(tree);

    bottomBoppers = new FlxSprite(-300, 140);
    bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
    bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
    bottomBoppers.antialiasing = true;
    bottomBoppers.scrollFactor.set(0.9, 0.9);
    bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
    bottomBoppers.updateHitbox();
    add(bottomBoppers);


    var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
    fgSnow.active = false;
    fgSnow.antialiasing = true;
    add(fgSnow);

    santa = new FlxSprite(-840, 150);
    santa.frames = Paths.getSparrowAtlas('christmas/santa');
    santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
    santa.antialiasing = true;
    add(santa);
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

    upperBoppers.animation.play('bop', true);
    bottomBoppers.animation.play('bop', true);
    santa.animation.play('idle', true);
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