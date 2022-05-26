#if SCRIPTS
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.utils.Assets as OpenFlAssets;
import Type.ValueType;

using StringTools;

class ExtraModChart
{
	public static var functionContinue:Dynamic = 0;
	public static var functionStop:Dynamic = 1;

	#if SCRIPTS
	public var lua:State = null;
	#end

	var daName:String = '';
	var daClose:Bool = false;
	var currentPlaystate:PlayState = null;
	var aboutToClose:Bool = false;

	public function new(luaScript:String)
	{
		#if SCRIPTS
		lua = LuaL.newstate();

		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

		var debugResult:Dynamic = LuaL.dofile(lua, luaScript);
		var debugResultString:String = Lua.tostring(lua, debugResult);

		if (debugResult != 0 && debugResultString != null)
		{
			lime.app.Application.current.window.alert(debugResultString, 'Error Parsing ModChart!');
			trace('Error Parsing ModChart!' + debugResultString);

			lua = null;

			return;
		}

		// oh my fuck this is ugly
		daName = luaScript;

		var newclass:Dynamic = FlxG.state;
		currentPlaystate = newclass;

		set('functionContinue', functionContinue);
		set('functionStop', functionStop);
		set('luaDebug', false);
		set('warnWhenDeprecated', true);
		set('screenWidth', FlxG.width);
		set('screenHeight', FlxG.height);
		set('cameraXAxis', 0);
		set('cameraYAxis', 0);
		set('curBeat', 0);
		set('curStep', 0);
		set('health', 1);
		set('score', 0);
		set('noteHits', 0);
		for (i in 0...4)
		{
			set('defaultPlayerStrumXAxis' + i, 0);
			set('defaultPlayerStrumYAxis' + i, 0);
			set('defaultPlayer2StrumXAxis' + i, 0);
			set('defaultPlayer2StrumYAxis' + i, 0);
		}
		set('player1', PlayState.SONG.player1);
		set('player2', PlayState.SONG.player2);
		set('crochet', Conductor.crochet);
		set('stepCrochet', Conductor.stepCrochet);
		set('currentBPM', Conductor.bpm);
		set('bpm', PlayState.SONG.bpm);
		set('scrollSpeed', PlayState.SONG.speed);
		set('songName', PlayState.SONG.song);
		set('songPosition', Conductor.songPosition);
		set('songLength', FlxG.sound.music.length);
		set('startedCountdown', false);
		set('startingSong', false);
		set('endingSong', false);
		set('mustHitSection', false);
		set('downScroll', FlxG.save.data.downscroll);
		set('opponentHealthBarColor', FlxG.save.data.downScroll);
		set('defaultBoyfriendX', currentPlaystate.boyfriend.x);
		set('defaultBoyfriendY', currentPlaystate.boyfriend.y);
		set('defaultOpponentX', currentPlaystate.dad.x);
		set('defaultOpponentY', currentPlaystate.dad.y);
		set('defaultGirlfriendX', currentPlaystate.gf.x);
		set('defaultGirlfriendY', currentPlaystate.gf.y);

		Lua_helper.add_callback(lua, 'getProperty', function(Var:String)
		{
			var bananaSplittedVar:Array<String> = Var.split('.');
			if (bananaSplittedVar.length > 1)
			{
				var swagProperty:Dynamic = Reflect.getProperty(currentPlaystate, bananaSplittedVar[0]);

				for (i in 1...bananaSplittedVar.length - 1)
				{
					swagProperty = Reflect.getProperty(swagProperty, bananaSplittedVar[i]);
				}
				return Reflect.getProperty(swagProperty, bananaSplittedVar[bananaSplittedVar.length - 1]);
			}
			return Reflect.getProperty(currentPlaystate, Var);
		});
		Lua_helper.add_callback(lua, 'setProperty', function(Var:String, value:Dynamic)
		{
			var bananaSplittedVar:Array<String> = Var.split('.');
			if (bananaSplittedVar.length > 1)
			{
				var swagProperty:Dynamic = Reflect.getProperty(currentPlaystate, bananaSplittedVar[0]);

				for (i in 1...bananaSplittedVar.length - 1)
				{
					swagProperty = Reflect.getProperty(swagProperty, bananaSplittedVar[i]);
				}
				return Reflect.getProperty(swagProperty, bananaSplittedVar[bananaSplittedVar.length - 1]);
			}
			return Reflect.getProperty(currentPlaystate, Var);
		});

		Lua_helper.add_callback(lua, 'getPropertyFromGroup', function(obj:String, index:Int, variable:Dynamic)
		{
			if (Std.isOfType(Reflect.getProperty(currentPlaystate, obj), FlxTypedGroup))
				return Reflect.getProperty(Reflect.getProperty(currentPlaystate, obj).members[index], variable);

			var daArray:Dynamic = Reflect.getProperty(currentPlaystate, obj)[index];

			if (daArray != null)
			{
				if (Type.typeof(variable) == ValueType.TInt)
					return daArray[variable];

				var splitterVar:Array<String> = variable.split('.');

				if (splitterVar.length > 1)
				{
					var swagProperty:Dynamic = Reflect.getProperty(daArray, splitterVar[0]);

					for (i in 1...splitterVar.length - 1)
					{
						swagProperty = Reflect.getProperty(swagProperty, splitterVar[i]);
					}

					return Reflect.getProperty(swagProperty, splitterVar[splitterVar.length - 1]);
				}

				return Reflect.getProperty(daArray, variable);
			}

			luaTrace("Object #" + index + " from group: " + obj + " doesn't exist!");
			return null;
		});

		Lua_helper.add_callback(lua, 'setPropertyFromGroup', function(obj:String, index:Int, variable:Dynamic, value:Dynamic)
		{
			if (Std.isOfType(Reflect.getProperty(currentPlaystate, obj), FlxTypedGroup))
				return Reflect.setProperty(Reflect.getProperty(currentPlaystate, obj).members[index], variable, value);

			var daArray:Dynamic = Reflect.getProperty(currentPlaystate, obj)[index];

			if (daArray != null)
			{
				if (Type.typeof(variable) == ValueType.TInt)
					return daArray[variable] = value;

				var splitterVar:Array<String> = variable.split('.');

				if (splitterVar.length > 1)
				{
					var swagProperty:Dynamic = Reflect.getProperty(daArray, splitterVar[0]);

					for (i in 1...splitterVar.length - 1)
					{
						swagProperty = Reflect.getProperty(swagProperty, splitterVar[i]);
					}

					return Reflect.setProperty(swagProperty, splitterVar[splitterVar.length - 1], value);
				}

				return Reflect.setProperty(daArray, variable, value);
			}
		});

		// this is where my attention span died and i just started reusing code lmao
		Lua_helper.add_callback(lua, 'removeFromGroup', function(obj:String, index:Int, dontdestroy:Bool = false)
		{
			if (Std.isOfType(Reflect.getProperty(currentPlaystate, obj), FlxTypedGroup))
			{
				var swagProperty = Reflect.getProperty(currentPlaystate, obj).members[index];

				if (!dontdestroy)
					swagProperty.kill();

				Reflect.getProperty(currentPlaystate, obj).remove(swagProperty, true);

				if (!dontdestroy)
					swagProperty.destroy();

				return;
			}

			Reflect.getProperty(currentPlaystate, obj).remove(Reflect.getProperty(currentPlaystate, obj)[index]);
		});

		Lua_helper.add_callback(lua, 'getPropertyFromClass', function(classVar:String, variable:String)
		{
			var splittedVar:Array<String> = variable.split('.');

			if (splittedVar.length > 1)
			{
				var swagProperty:Dynamic = Reflect.getProperty(Type.resolveClass(classVar), splittedVar[0]);

				for (i in 1...splittedVar.length - 1)
				{
					swagProperty = Reflect.getProperty(swagProperty, splittedVar[i]);
				}

				return Reflect.getProperty(swagProperty, splittedVar[splittedVar.length - 1]);
			}

			return Reflect.getProperty(Type.resolveClass(classVar), variable);
		});

		Lua_helper.add_callback(lua, 'setPropertyFromClass', function(classVar:String, variable:String, value:Dynamic)
		{
			var splittedVar:Array<String> = variable.split('.');

			if (splittedVar.length > 1)
			{
				var swagProperty:Dynamic = Reflect.getProperty(Type.resolveClass(classVar), splittedVar[0]);

				for (i in 1...splittedVar.length - 1)
				{
					swagProperty = Reflect.getProperty(swagProperty, splittedVar[i]);
				}

				return Reflect.setProperty(swagProperty, splittedVar[splittedVar.length - 1], value);
			}

			return Reflect.setProperty(Type.resolveClass(classVar), variable, value);
		});

		Lua_helper.add_callback(lua, "doTweenX", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String)
		{
			var fuckingshit:Dynamic = tweenShit(tag, vars);
			if (fuckingshit != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(fuckingshit, {x: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
			else
			{
				luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenY", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String)
		{
			var fuckingshit:Dynamic = tweenShit(tag, vars);
			if (fuckingshit != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(fuckingshit, {y: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
			else
			{
				luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenAngle", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String)
		{
			var fuckingshit:Dynamic = tweenShit(tag, vars);
			if (fuckingshit != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(fuckingshit, {angle: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
			else
			{
				luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenAlpha", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String)
		{
			var fuckingshit:Dynamic = tweenShit(tag, vars);
			if (fuckingshit != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(fuckingshit, {alpha: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
			else
			{
				luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenZoom", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String)
		{
			var fuckingshit:Dynamic = tweenShit(tag, vars);
			if (fuckingshit != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(fuckingshit, {zoom: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
			else
			{
				luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenColor", function(tag:String, vars:String, targetColor:String, duration:Float, ease:String)
		{
			var fuckingshit:Dynamic = tweenShit(tag, vars);
			if (fuckingshit != null)
			{
				var color:Int = Std.parseInt(targetColor);
				if (!targetColor.startsWith('0x'))
					color = Std.parseInt('0xff' + targetColor);

				currentPlaystate.modchartTweens.set(tag, FlxTween.color(fuckingshit, duration, fuckingshit.color, color, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.modchartTweens.remove(tag);
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
					}
				}));
			}
			else
			{
				luaTrace('Couldnt find object: ' + vars);
			}
		});

		Lua_helper.add_callback(lua, "doNoteTweenX", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String)
		{
			cancelTween(tag);
			if (note < 0)
				note = 0;
			var iamcoolbro:FlxSprite;
			iamcoolbro = currentPlaystate.strumLineNotes.members[note % currentPlaystate.strumLineNotes.length];

			if (iamcoolbro != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(iamcoolbro, {x: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
		});
		Lua_helper.add_callback(lua, "doNoteTweenY", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String)
		{
			cancelTween(tag);
			if (note < 0)
				note = 0;
			var iamcoolbro:FlxSprite;
			iamcoolbro = currentPlaystate.strumLineNotes.members[note % currentPlaystate.strumLineNotes.length];

			if (iamcoolbro != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(iamcoolbro, {y: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
		});
		Lua_helper.add_callback(lua, "doNoteTweenAngle", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String)
		{
			cancelTween(tag);
			if (note < 0)
				note = 0;
			var iamcoolbro:FlxSprite;
			iamcoolbro = currentPlaystate.strumLineNotes.members[note % currentPlaystate.strumLineNotes.length];

			if (iamcoolbro != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(iamcoolbro, {angle: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
		});
		Lua_helper.add_callback(lua, "doTweenTransparency", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String)
		{
			cancelTween(tag);
			if (note < 0)
				note = 0;
			var iamcoolbro:FlxSprite;
			iamcoolbro = currentPlaystate.strumLineNotes.members[note % currentPlaystate.strumLineNotes.length];

			if (iamcoolbro != null)
			{
				currentPlaystate.modchartTweens.set(tag, FlxTween.tween(iamcoolbro, {alpha: value}, duration, {
					ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween)
					{
						currentPlaystate.callOnLuas('onTweenCompleted', [tag]);
						currentPlaystate.modchartTweens.remove(tag);
					}
				}));
			}
		});

		Lua_helper.add_callback(lua, "cancelTween", function(tag:String)
		{
			cancelTween(tag);
		});

		Lua_helper.add_callback(lua, "runTimer", function(tag:String, time:Float = 1, loops:Int = 1)
		{
			cancelTimer(tag);
			currentPlaystate.modchartTimers.set(tag, new FlxTimer().start(time, function(tmr:FlxTimer)
			{
				if (tmr.finished)
				{
					currentPlaystate.modchartTimers.remove(tag);
				}
				currentPlaystate.callOnLuas('onComplete', [tag, tmr.loops, tmr.loopsLeft]);
				// trace('Timer Completed: ' + tag);
			}, loops));
		});
		Lua_helper.add_callback(lua, "cancelTimer", function(tag:String)
		{
			cancelTimer(tag);
		});

		// Regular functions
		Lua_helper.add_callback(lua, 'increaseHealth', function(value:Float = 0)
		{
			currentPlaystate.health += value;
		});

		Lua_helper.add_callback(lua, 'setHealth', function(value:Float = 0)
		{
			currentPlaystate.health = value;
		});

		Lua_helper.add_callback(lua, 'increaseHealthFromPercent', function(value:Float = 0)
		{
			currentPlaystate.health += (value / 100);
		});

		Lua_helper.add_callback(lua, 'setHealthFromPercent', function(value:Float = 0)
		{
			currentPlaystate.health = (value / 100);
		});

		Lua_helper.add_callback(lua, 'increaseCombo', function(value:Int = 0)
		{
			currentPlaystate.combo += value;
		});

		Lua_helper.add_callback(lua, 'setCombo', function(value:Int = 0)
		{
			currentPlaystate.combo = value;
		});

		Lua_helper.add_callback(lua, 'getColorFromHexadecimal', function(hex:String = '0xFF000000'):FlxColor
		{
			if (!hex.startsWith('0x'))
				hex = '0x' + hex;

			return FlxColor.fromString(hex);
		});

		Lua_helper.add_callback(lua, 'getColorFromRgb', function(r:Int = 0, g:Int = 0, b:Int = 0):FlxColor
		{
			return FlxColor.fromRGB(r, g, b);
		});

		Lua_helper.add_callback(lua, 'getCamFromString', function(cam:String = 'game'):FlxCamera
		{
			var curCamera:FlxCamera = currentPlaystate.camGame;

			switch (cam.toLowerCase())
			{
				case 'camhud' | 'hud':
					curCamera = currentPlaystate.camHUD;
				case 'camgame' | 'game':
					curCamera = currentPlaystate.camGame;
			}

			return curCamera;
		});

		Lua_helper.add_callback(lua, 'getStrumlinePosition', function(axis:String = 'X'):Float
		{
			var curPos:Float = 0;

			switch (axis.toUpperCase())
			{
				case 'X':
					curPos = currentPlaystate.strumLine.x;
				case 'Y':
					curPos = currentPlaystate.strumLine.y;
			}

			return curPos;
		});

		Lua_helper.add_callback(lua, 'getStrumamount', function(player:String = 'player'):Int
		{
			var curAmount:Int = 0;

			switch (player.toLowerCase())
			{
				case 'player1':
					curAmount = currentPlaystate.playerStrums.length;
				case 'player2':
					curAmount = currentPlaystate.dadStrums.length;
				case 'both':
					curAmount = currentPlaystate.strumLineNotes.length;
			}

			return curAmount;
		});

		Lua_helper.add_callback(lua, 'getSongPos', function(round:Bool = false):Float
		{
			if (!round)
				return Conductor.songPosition;
			else
				return Math.round(Conductor.songPosition);
		});

		Lua_helper.add_callback(lua, 'getCharacterPos', function(character:String = 'bf', axis:String = 'X'):Float
		{
			var curCharacter:Character = null;
			var curPos:Float = 0;

			switch (character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					curCharacter = currentPlaystate.dad;
				case 'gf' | 'girlfriend':
					curCharacter = currentPlaystate.gf;
				case 'boyfriend' | 'player1':
					curCharacter = currentPlaystate.boyfriend;
			}

			if (curCharacter != null)
			{
				switch (axis.toUpperCase())
				{
					case 'X':
						curPos = curCharacter.x;
					case 'Y':
						curPos = curCharacter.y;
				}
			}

			return curPos;
		});

		Lua_helper.add_callback(lua, 'characterPlayAnim', function(character:String = 'bf', animation:String = 'idle', ?forced:Bool = false)
		{
			switch (character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					if (currentPlaystate.dad.animOffsets.exists(animation))
						currentPlaystate.dad.playAnim(animation, forced);
				case 'gf' | 'girlfriend':
					if (currentPlaystate.gf.animOffsets.exists(animation))
						currentPlaystate.gf.playAnim(animation, forced);
				case 'boyfriend' | 'player1':
					if (currentPlaystate.boyfriend.animOffsets.exists(animation))
						currentPlaystate.boyfriend.playAnim(animation, forced);
			}
		});

		Lua_helper.add_callback(lua, 'characterDance', function(character:String = 'bf')
		{
			switch (character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					currentPlaystate.dad.dance();
				case 'gf' | 'girlfriend' | 'player3':
					currentPlaystate.gf.dance();
				case 'boyfriend' | 'player1':
					currentPlaystate.boyfriend.dance();
			}
		});

		Lua_helper.add_callback(lua, 'cameraShake', function(cam:String = 'game', intensity:Float = 0.1, duration:Float = 1)
		{
			getCamFromString(cam).shake(intensity, duration);
		});

		Lua_helper.add_callback(lua, 'cameraFlashFromHex', function(cam:String = 'game', color:String = '0xFF000000', duration:Float = 1)
		{
			if (!color.startsWith('0x'))
				color = '0x' + color;

			getCamFromString(cam).flash(FlxColor.fromString(color), duration);
		});

		Lua_helper.add_callback(lua, 'cameraFlashFromRgb', function(cam:String = 'game', r:Int = 0, g:Int = 0, b:Int = 0, duration:Float = 1)
		{
			getCamFromString(cam).flash(FlxColor.fromRGB(r, g, b), duration);
		});

		Lua_helper.add_callback(lua, 'songEnd', function()
		{
			currentPlaystate.endSong();
		});

		Lua_helper.add_callback(lua, 'debugPrint', function(text:String = 'placeholder')
		{
			#if debug
			luaTrace(text, true, false);
			#end
		});

		Lua_helper.add_callback(lua, 'print', function(text:String = 'placeholder')
		{
			luaTrace(text, true, false);
		});

		Lua_helper.add_callback(lua, 'close', function(printMsg:Bool = true)
		{
			if (!aboutToClose)
			{
				if (printMsg)
					luaTrace('Stopping Lua Script, Thanks for using Extra Engine Lua!: ' + daName);

				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					stop();
				});
			}

			aboutToClose = true;
		});

		call('onCreate', []);
		#end
	}

	public function getCamFromString(cam:String = 'game'):FlxCamera
	{
		var curCamera:FlxCamera = currentPlaystate.camGame;

		switch (cam.toLowerCase())
		{
			case 'camhud' | 'hud':
				curCamera = currentPlaystate.camHUD;
			case 'camgame' | 'game':
				curCamera = currentPlaystate.camGame;
		}

		return curCamera;
	}

	public function luaTrace(text:String = 'placeholder', ignoreCheck:Bool = false, deprecated:Bool = false)
	{
		#if SCRIPTS
		if (ignoreCheck || getBool('luaDebugMode'))
		{
			if (deprecated && !getBool('luaDeprecatedWarnings'))
				return;

			var tracedText:String = (deprecated ? 'Deprecated message: ' : '') + text;
			trace(tracedText);
		}
		#end
	}

	public function call(event:String, args:Array<Dynamic>):Dynamic
	{
		#if SCRIPTS
		if (lua == null)
		{
			return functionContinue;
		}

		Lua.getglobal(lua, event);

		for (arg in args)
		{
			Convert.toLua(lua, arg);
		}

		var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);
		if (result != null)
		{
			/*var resultStr:String = Lua.tostring(lua, result);
				var error:String = Lua.tostring(lua, -1);
				Lua.pop(lua, 1); */
			if (Lua.type(lua, -1) == Lua.LUA_TSTRING)
			{
				var error:String = Lua.tostring(lua, -1);
				Lua.pop(lua, 1);
				if (error == 'attempt to call a nil value')
				{
					return functionContinue;
				}
			}

			var conv:Dynamic = Convert.fromLua(lua, result);
			return conv;
		}
		#end
		return functionContinue;
	}

	#if SCRIPTS
	function debugResultIsAllowed(daLua:State, dadebugResult:Null<Int>)
	{
		switch (Lua.type(daLua, dadebugResult))
		{
			case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
				return true;
		}

		return false;
	}
	#end

	#if SCRIPTS
	public function getBool(variable:String)
	{
		var debugResult:String = null;

		Lua.getglobal(lua, variable);
		debugResult = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if (debugResult == null)
			return false;

		return (debugResult == 'true');
	}
	#end

	public function set(variable:String, data:Dynamic)
	{
		#if SCRIPTS
		if (lua == null)
			return;

		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
		#end
	}

	public function stop()
	{
		#if SCRIPTS
		if (lua == null)
			return;

		currentPlaystate.removeLua(this);
		Lua.close(lua);
		lua = null;
		#end
	}

	// basically all that was taken since i suck at tweening
	function cancelTween(tag:String)
	{
		if (currentPlaystate.modchartTweens.exists(tag))
		{
			currentPlaystate.modchartTweens.get(tag).cancel();
			currentPlaystate.modchartTweens.get(tag).destroy();
			currentPlaystate.modchartTweens.remove(tag);
		}
	}

	function tweenShit(tag:String, vars:String)
	{
		cancelTween(tag);
		var variables:Array<String> = vars.replace(' ', '').split('.');
		// sus
		var sexyProp:Dynamic = Reflect.getProperty(currentPlaystate, variables[0]);
		if (sexyProp == null && currentPlaystate.modchartSprites.exists(variables[0]))
		{
			sexyProp = currentPlaystate.modchartSprites.get(variables[0]);
		}

		for (i in 1...variables.length)
		{
			sexyProp = Reflect.getProperty(sexyProp, variables[i]);
		}
		return sexyProp;
	}

	function cancelTimer(tag:String)
	{
		if (currentPlaystate.modchartTimers.exists(tag))
		{
			var theTimer:FlxTimer = currentPlaystate.modchartTimers.get(tag);
			theTimer.cancel();
			theTimer.destroy();
			currentPlaystate.modchartTimers.remove(tag);
		}
	}

	function getFlxEaseByString(?ease:String = '')
	{
		switch (ease.toLowerCase().trim())
		{
			case 'backin':
				return FlxEase.backIn;
			case 'backinout':
				return FlxEase.backInOut;
			case 'backout':
				return FlxEase.backOut;
			case 'bouncein':
				return FlxEase.bounceIn;
			case 'bounceinout':
				return FlxEase.bounceInOut;
			case 'bounceout':
				return FlxEase.bounceOut;
			case 'circin':
				return FlxEase.circIn;
			case 'circinout':
				return FlxEase.circInOut;
			case 'circout':
				return FlxEase.circOut;
			case 'cubein':
				return FlxEase.cubeIn;
			case 'cubeinout':
				return FlxEase.cubeInOut;
			case 'cubeout':
				return FlxEase.cubeOut;
			case 'elasticin':
				return FlxEase.elasticIn;
			case 'elasticinout':
				return FlxEase.elasticInOut;
			case 'elasticout':
				return FlxEase.elasticOut;
			case 'expoin':
				return FlxEase.expoIn;
			case 'expoinout':
				return FlxEase.expoInOut;
			case 'expoout':
				return FlxEase.expoOut;
			case 'quadin':
				return FlxEase.quadIn;
			case 'quadinout':
				return FlxEase.quadInOut;
			case 'quadout':
				return FlxEase.quadOut;
			case 'quartin':
				return FlxEase.quartIn;
			case 'quartinout':
				return FlxEase.quartInOut;
			case 'quartout':
				return FlxEase.quartOut;
			case 'quintin':
				return FlxEase.quintIn;
			case 'quintinout':
				return FlxEase.quintInOut;
			case 'quintout':
				return FlxEase.quintOut;
			case 'sinein':
				return FlxEase.sineIn;
			case 'sineinout':
				return FlxEase.sineInOut;
			case 'sineout':
				return FlxEase.sineOut;
			case 'smoothstepin':
				return FlxEase.smoothStepIn;
			case 'smoothstepinout':
				return FlxEase.smoothStepInOut;
			case 'smoothstepout':
				return FlxEase.smoothStepInOut;
			case 'smootherstepin':
				return FlxEase.smootherStepIn;
			case 'smootherstepinout':
				return FlxEase.smootherStepInOut;
			case 'smootherstepout':
				return FlxEase.smootherStepOut;
		}
		return FlxEase.linear;
	}

	function cameraFromString(cam:String):FlxCamera
	{
		switch (cam.toLowerCase())
		{
			case 'camhud' | 'hud':
				return currentPlaystate.camHUD;
		}
		return currentPlaystate.camGame;
	}
}

class LuaSprite extends FlxSprite
{
	public var wasAdded:Bool = false;

	public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);
		antialiasing = true;
	}
}
