package com.andrievsky.videoconference.model
{
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.effects.Animate;
	import spark.effects.AnimateFilter;
	import spark.effects.Fade;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.filters.BlurFilter;
	
	public class GraphicModel extends Actor
	{
		private var isReady:Boolean = false;
		private var enableAnimate:Animate;
		private var disableAnimate:Animate;
		public function lock():void
		{
			if (!FlexGlobals.topLevelApplication.enabled) return;
			CursorManager.setBusyCursor();
			FlexGlobals.topLevelApplication.enabled = false;
			//disableAnimation();
		}
		
		public function unlock():void
		{
			if (FlexGlobals.topLevelApplication.enabled) return;
			CursorManager.removeBusyCursor();
			FlexGlobals.topLevelApplication.enabled = true;
			
			//enableAnimation();
		}
		private function init():void
		{
			enableAnimate = new Fade(FlexGlobals.topLevelApplication);
			enableAnimate.duration = 2;
			(enableAnimate as Fade).alphaFrom = 0;
			(enableAnimate as Fade).alphaTo = 1;
			disableAnimate = new Fade(FlexGlobals.topLevelApplication);
			disableAnimate.duration = 2;
			(disableAnimate as Fade).alphaFrom = 1;
			(disableAnimate as Fade).alphaTo = 0;
			isReady = true;
		}
		private function enableAnimation():void
		{
			if (!isReady) init();
			if (disableAnimate.isPlaying)
			{
				disableAnimate.reverse();
			}
			else
			{
				enableAnimate.play();
			}
		}
		private function disableAnimation():void
		{
			if (!isReady) init();
			if (enableAnimate.isPlaying)
			{
				enableAnimate.reverse();
			}
			else
			{
				disableAnimate.play();
			}
		}
	}
}