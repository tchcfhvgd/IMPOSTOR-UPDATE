package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import WeekData;
import openfl.utils.Assets as OpenFlAssets;


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

#if sys
import sys.FileSystem;
#end

class BlackRematchState extends MusicBeatState
{

	override function create()
	{
		super.create();

        startVideo('finale');
    }

   function goToMenu(){
        if(ClientPrefs.finaleState != NOT_PLAYED || ClientPrefs.finaleState != COMPLETED)
            ClientPrefs.finaleState = NOT_PLAYED;

        ClientPrefs.saveSettings();
        LoadingState.loadAndSwitchState(new TitleState(), true);
   }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
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
			goToMenu();
			return;
		}

		var video:MP4Handler = new MP4Handler();
		#if (hxCodec < "3.0.0")
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			goToMenu();
			return;
		}
		#else
		video.play(filepath);
		video.onEndReached.add(function(){
			video.dispose();
			goToMenu();
			return;
		});
		#end
		#else
		FlxG.log.warn('Platform not supported!');
		goToMenu();
		return;
		#end
	}
}
