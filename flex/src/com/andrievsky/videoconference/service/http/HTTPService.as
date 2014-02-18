package com.andrievsky.videoconference.service.http
{
	import com.andrievsky.videoconference.event.HTTPServiceEvent;
	
	import org.robotlegs.mvcs.Actor;
	
	public class HTTPService extends Actor
	{
		public function getMediaList():void
		{
			var value:Array = ["sample.mp4","sample.mp4","sample.mp4","sample.mp4","sample.mp4" ]
			//dispatch(new HTTPServiceEvent(HTTPServiceEvent.GET_MEDIA_LIST, value));
		}
	}
}