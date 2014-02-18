package com.andrievsky.videoconference.util.video
{
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class VideoUtil
	{
		public static function mirrorVideo(videoSprite:Sprite):void{
			var w:int=videoSprite.width
			var ma:Matrix=new Matrix();
			ma.a=-1;
			ma.tx=w;
			videoSprite.transform.matrix=ma;
		}
	}
}