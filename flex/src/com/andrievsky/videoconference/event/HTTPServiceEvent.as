package com.andrievsky.videoconference.event
{
	import flash.events.Event;
	
	public class HTTPServiceEvent extends Event
	{
		public static const GET_MEDIA_LIST:String = "HTTPServiceEvent.GET_MEDIA_LIST";
		
		public var data:* = null;
		
		public function HTTPServiceEvent(type:String, data:* = null)
		{
			if (data) this.data = data;
			super(type, false, false);
		}
	}
}