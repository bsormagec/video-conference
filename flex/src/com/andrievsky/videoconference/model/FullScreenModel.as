package com.andrievsky.videoconference.model
{
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import org.robotlegs.mvcs.Actor;
	
	public class FullScreenModel extends Actor
	{
		private var backgroundElement:IVisualElement;
		private var backgroundParent:IVisualElementContainer;
		private var backgroundPosition:int;
		private var controlsElement:IVisualElement;
		private var controlsParent:IVisualElementContainer;
		private var controlsdPosition:int;
		private var isInit:Boolean = false;
		
		public function isFullScreen():Boolean
		{
			return (FlexGlobals.topLevelApplication.systemManager.stage.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		private function init():void
		{
			FlexGlobals.topLevelApplication.systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenHandler);
			isInit = true;
		}
		
		private function fullScreenHandler(evt:FullScreenEvent):void {
			if (evt.fullScreen) {
				/* Do something specific here if we switched to full screen mode. */
			} else {
				switchToNormalScreen();
			}
		}
		
		public function switchToFullScreen(background:IVisualElement, controls:IVisualElement):void
		{
			if (!isInit) init();
			backgroundElement = background;
			backgroundParent = backgroundElement.parent as IVisualElementContainer;
			backgroundPosition = (backgroundElement.parent as IVisualElementContainer).getElementIndex(backgroundElement);
			controlsElement = controls;
			controlsParent = controlsElement.parent as IVisualElementContainer;
			controlsdPosition = (controlsElement.parent as IVisualElementContainer).getElementIndex(controlsElement);
			FlexGlobals.topLevelApplication.mainView.fullScreenBackground.addElement(backgroundElement);
			FlexGlobals.topLevelApplication.mainView.fullScreenControls.addElement(controlsElement);
			FlexGlobals.topLevelApplication.systemManager.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		public function switchToNormalScreen():void 
		{
			if (!isInit) init();
			backgroundParent.addElementAt(backgroundElement, backgroundPosition);
			backgroundElement = null;
			backgroundPosition = NaN;
			controlsParent.addElementAt(controlsElement, controlsdPosition);
			controlsElement = null;
			controlsdPosition = NaN;
			FlexGlobals.topLevelApplication.systemManager.stage.displayState = StageDisplayState.NORMAL;
		}
	}
}