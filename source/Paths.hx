package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import lime.utils.Assets;
import flash.media.Sound;
#if MODS
import sys.io.File;
import sys.FileSystem;
#end

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	static var currentLevel:String;

	public static var localTrackedAssets:Array<String> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];

	static public var modDir:String = null;

	public static var customImagesLoaded:Map<String, Bool> = new Map<String, Bool>();
	public static var customSoundsLoaded:Map<String, Sound> = new Map();

	public static var ignoredFolders:Array<String> = [
		'custom_characters', 'images', 'data', 'songs', 'stages', 'music', 'sounds'
	];

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline public static function getPreloadPath(file:String = '')
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	static public function video(key:String)
	{
		return 'assets/videos/$key.$VIDEO_EXT';
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function txtImage(key:String, ?library:String)
	{
		return getPath('images/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String):Dynamic
	{
		var file:Sound = addCustomSound('music', key);
		return file;
	}

	inline static public function voices(song:String):Any
	{
		#if MODS
		var file:Sound = returnSongFile(modsSongs(song.toLowerCase() + '/Voices'));
		if (file != null)
		{
			return file;
		}
		#end
	
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}
	
	inline static public function inst(song:String):Any
	{
		#if MODS
		var file:Sound = returnSongFile(modsSongs(song.toLowerCase() + '/Inst'));
		if (file != null)
		{
			return file;
		}
		#end
	
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}
	
	inline static private function returnSongFile(file:String):Sound
	{
		#if MODS
		if (FileSystem.exists(file))
		{
			if (!customSoundsLoaded.exists(file))
			{
				customSoundsLoaded.set(file, Sound.fromFile(file));
			}
			return customSoundsLoaded.get(file);
		}
		#end
		return null;
	}

	inline static public function image(key:String, ?library:String):Dynamic
	{
		#if MODS
		var imageToReturn:FlxGraphic = addCustomGraphic(key);
		if (imageToReturn != null)
			return imageToReturn;
		#end
		return getPath('images/$key.png', IMAGE);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function getModsSparrowAtlas(key:String, ?library:String)
	{
		var imageLoaded:FlxGraphic = addCustomGraphic(key);
		var xmlExists:Bool = false;
		if (FileSystem.exists(modsXml(key)))
		{
			xmlExists = true;
		}

		return FlxAtlasFrames.fromSparrow((imageLoaded != null ? imageLoaded : image(key, library)),
			(xmlExists ? File.getContent(modsXml(key)) : file('images/$key.xml', library)));
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{
		#if MODS
		if (FileSystem.exists(mods(key)) || FileSystem.exists(mods(key)))
		{
			return true;
		}
		#else
		if (OpenFlAssets.exists(Paths.getPath(key, type, library)))
		{
			return true;
		}
		#end
		return false;
	}

	static public function addCustomGraphic(key:String):FlxGraphic
	{
		#if MODS
		if (FileSystem.exists(modsImages(key)))
		{
			if (!customImagesLoaded.exists(key))
			{
				var newBitmap:BitmapData = BitmapData.fromFile(modsImages(key));
				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, key);
				newGraphic.persist = true;
				FlxG.bitmap.addGraphic(newGraphic);
				customImagesLoaded.set(key, true);
			}
			return FlxG.bitmap.get(key);
		}
		#end
		return null;
	}

	public static function addCustomSound(path:String, key:String, ?library:String)
	{
		#if MODS
		var file:String = modSound(path, key);
		if (FileSystem.exists(file))
		{
			if (!currentTrackedSounds.exists(file))
			{
				currentTrackedSounds.set(file, Sound.fromFile(file));
			}
			localTrackedAssets.push(key);
			return currentTrackedSounds.get(file);
		}
		#end
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if (!currentTrackedSounds.exists(gottenPath))
			#if MODS
			currentTrackedSounds.set(gottenPath, Sound.fromFile('./' + gottenPath));
			#else
			currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(getPath('$path/$key.$SOUND_EXT', SOUND, library)));
			#end
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}

	static public function modFolder(key:String)
	{
		#if MODS
		var list:Array<String> = [];
		var modsFolder:String = Paths.mods();
		if (FileSystem.exists(modsFolder))
		{
			for (folder in FileSystem.readDirectory(modsFolder))
			{
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !Paths.ignoredFolders.contains(folder) && !list.contains(folder))
				{
					list.push(folder);
					for (i in 0...list.length)
					{
						modDir = list[i];
					}
				}
			}
		}

		return 'mods/' + key;
		#else
		return key;
		#end
	}

	inline static public function mods(key:String = '')
	{
		return 'mods/' + key;
	}

	inline static public function modsXml(key:String)
	{
		return modFolder('images/' + key + '.xml');
	}

	inline static public function modsImages(key:String)
	{
		return modFolder('images/' + key + '.png');
	}

	inline static public function modsSongs(key:String)
	{
		return modFolder('songs/' + key + '.' + SOUND_EXT);
	}
	
	inline static public function modSong(key:String)
	{
		return modFolder(key + '.json');
	}
	
	inline static public function modsJson(key:String)
	{	
		return modFolder('data/' + key + '.json');
	}

	inline static public function modSound(path:String, key:String)
	{
		return modFolder(path + '/' + key + '.' + SOUND_EXT);
	}
}
