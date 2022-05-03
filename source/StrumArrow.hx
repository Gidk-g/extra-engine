package;

import flixel.FlxG;
import haxe.ds.IntMap;
import flixel.FlxSprite;

using StringTools;
class StrumArrow extends FlxSprite {
    
    public var data:Int;

    public function new(x:Float = 0, y:Float = 0, data:Int) {
        super(x, y);
        this.data = data;

        createAnimations();

        
		scrollFactor.set();
        ID = data;

        playAnim('static');
    }

    public function createAnimations() {

        var wordMap:IntMap<String> = new IntMap<String>();
        wordMap.set(0, "LEFT");
        wordMap.set(1, "DOWN");
        wordMap.set(2, "UP");
        wordMap.set(3, "RIGHT");

        switch (PlayState.curStage.toLowerCase()) {
            case 'school' | 'schoolevil':
                
                loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

                setGraphicSize(Std.int(width * PlayState.daPixelZoom));
                updateHitbox();

                antialiasing = false;

                animation.add('green', [6]);
                animation.add('red', [7]);
                animation.add('blue', [5]);
                animation.add('purplel', [4]);

                x += Note.swagWidth * data;
                animation.add('static', [data]);
                animation.add('pressed', [4 + data, 8 + data], 12, false);
                animation.add('confirm', [12 + data, 16 + data], 24, false);
            default:
                frames = Paths.getSparrowAtlas('NOTE_assets');

                setGraphicSize(Std.int(width * 0.7));
                updateHitbox();

                antialiasing = true;

                animation.addByPrefix('green', 'arrowUP');
                animation.addByPrefix('blue', 'arrowDOWN');
                animation.addByPrefix('purple', 'arrowLEFT');
                animation.addByPrefix('red', 'arrowRIGHT');

                var dataThing:String = wordMap.get(data);

                var lower:String = dataThing.toLowerCase();

                x += Note.swagWidth * data;
                animation.addByPrefix('static', 'arrow$dataThing');
                animation.addByPrefix('pressed', '$lower press', 24, false);
                animation.addByPrefix('confirm', '$lower confirm', 24, false);
        }
    }

    public var holdTimer:Float = 0;

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (holdTimer > 0) {
            holdTimer -= elapsed;
            if (holdTimer <= 0) {
                playAnim('static');
                holdTimer = 0;
            }
        }

    }

    public function noteHit(note:Note) {
        if (FlxG.save.data.botplay) {
            var time:Float = 0.15;
            if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
                time += 0.15;
            }
            holdTimer = time;

            playAnim('confirm');
        } else {
            playAnim('confirm');
        }
    }

    public inline function playAnim(name:String, ?forced:Bool = true) {
        animation.play(name, true);

        offset.set(frameWidth / 2, frameHeight / 2);

		offset.x -= 54;
		offset.y -= 56;
    }
}