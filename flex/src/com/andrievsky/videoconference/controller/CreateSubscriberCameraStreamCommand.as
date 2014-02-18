package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.StreamModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class CreateSubscriberCameraStreamCommand extends Command
	{
		[Inject]
		public var streamModel:StreamModel;
		
		override public function execute():void
		{
			streamModel.publishSubscriberCameraStream();
		}
	}
}