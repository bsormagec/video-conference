package com.andrievsky.videoconference.view.loading
{
	import com.andrievsky.videoconference.event.LoadingEvent;
	import com.andrievsky.videoconference.event.MainEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LoadingMediator extends Mediator
	{
		[Inject]
		public var view:LoadingView;
		
		override public function onRegister():void
		{
			dispatch(new LoadingEvent(LoadingEvent.LOADING_COMPLETE, this.view));
		}
	}
}