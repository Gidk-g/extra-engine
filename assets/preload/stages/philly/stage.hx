var lights:Array<FlxSprite> = [];
var phillyTrain:FlxSprite;
var trainSound:FlxSound;

var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;

var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;
var startedMoving:Bool = false;

function createBackground()
{
    // This happens BEFORE BF and GF get put.

    var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
    bg.scrollFactor.set(0.1, 0.1);
    add(bg);

    var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
    city.scrollFactor.set(0.3, 0.3);
    city.setGraphicSize(Std.int(city.width * 0.85));
    city.updateHitbox();
    add(city);

    for (i in 0...5) 
    {
        var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
        light.scrollFactor.set(0.3, 0.3);
        light.visible = false;
        light.setGraphicSize(Std.int(light.width * 0.85));
        light.updateHitbox();
        light.antialiasing = true;
        lights.push(light);
        add(light);
    }

    var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
    add(streetBehind);

    phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));

    add(phillyTrain);

    trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
    FlxG.sound.list.add(trainSound);

    var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
    add(street);
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

    if (!trainMoving)
        trainCooldown += 1;

    if (curBeat % 4 == 0)
    {
        for (light in lights)
            light.visible = false;

        curLight = FlxG.random.int(0, lights.length - 1);

        lights[curLight].visible = true;
    }

    if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
    {
        trainCooldown = FlxG.random.int(-4, 0);
        trainStart();
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

    if (trainMoving)
    {
        trainFrameTiming += elapsed;

        if (trainFrameTiming >= 1 / 24)
        {
            updateTrainPos();
            trainFrameTiming = 0;
        }
    }
}

function updateTrainPos():Void
{
    if (trainSound.time >= 4700)
    {
        startedMoving = true;
        gf.specialAnim = true;
        gf.playAnim('hairBlow');
    }

    if (startedMoving)
    {
        phillyTrain.x -= 400;

        if (phillyTrain.x < -2000 && !trainFinishing)
        {
            phillyTrain.x = -1150;
            trainCars -= 1;

            if (trainCars <= 0)
                trainFinishing = true;
        }

        if (phillyTrain.x < -4000 && trainFinishing)
            trainReset();
    }
}

function trainReset():Void
{
	gf.danced = false;
    gf.specialAnim = true;
    gf.playAnim('hairFall');
    phillyTrain.x = FlxG.width + 200;
    trainMoving = false;
    trainCars = 8;
    trainFinishing = false;
    startedMoving = false;
}

function trainStart():Void
{
    trainMoving = true;
    if (!trainSound.playing)
        trainSound.play(true);
}