package com.andrievsky.videoconference.model
{
	import org.robotlegs.mvcs.Actor;
	
	public class ConfigModel extends Actor
	{
		public function init():void
		{
			
		}
		
		public function get protocolName():String
		{
			return "http";
		}
		
		public function get serverName():String
		{
			return "localhost";
		}
		
		public function get serverPort():String
		{
			return "1935";
		}
		
		public function get applicationName():String
		{
			return "vod";
		}
		
		public function get decoder():String
		{
			return "mp4";
		}
		
		public function get manifest():String
		{
			return "manifest.f4m";
		}

		public function getClipPath(clipName:String):String
		{
			return protocolName+"://"+serverName+":"+serverPort+"/"+applicationName+"/"+decoder+":"+clipName+"/"+manifest;
		}
		
		public function get APPLICATION_PATH():String
		{
			return "rtmp://server:1935/app";		}
	}
}
