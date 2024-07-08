package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0")
import hxcodec.flixel.FlxVideo as MP4Handler;
#elseif (hxCodec == "2.6.1")
import hxcodec.VideoHandler as MP4Handler;
#elseif (hxCodec == "2.6.0")
import VideoHandler as MP4Handler;
#else
import vlc.MP4Handler;
#end
#end


using StringTools;

class CreditsVideo extends FlxState
{
	var video:VideoHandler;
	var titleState = new TitleState();

	override public function create():Void
	{

		super.create();
	        startVideo('credits');
	
	}

	override public function update(elapsed:Float){

		super.update(elapsed);

	}

	function next():Void{
		FlxG.switchState(titleState);
	}

        public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			next();
			return;
		}

		var video:MP4Handler = new MP4Handler();
		#if (hxCodec < "3.0.0")
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			next();
			return;
		}
		#else
		video.play(filepath);
		video.onEndReached.add(function(){
			video.dispose();
			next();
			return;
		});
		#end
		#else
		FlxG.log.warn('Platform not supported!');
		next();
		return;
		#end
	}

	
}
