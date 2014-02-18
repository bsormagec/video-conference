package com.andrievsky.videoconference.event
{
	import flash.events.Event;
	
	public class LoadingEvent extends Event
	{
		public static const LOADING_COMPLETE:String = "LoadingEvent.LOADING_COMPLETE";
		public var data:Object;
		
		public function LoadingEvent(type:String, data:Object=null)
		{
			if(data) this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}