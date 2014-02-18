package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.StreamModel;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddSubscriberCameraStreamCommand extends Command
	{
		[Inject]
		public var rtmpService:RTMPService;
		[Inject]
		public var roomModel:RoomModel;
		[Inject]
		public var streamModel:StreamModel;
		
		override public function execute():void
		{
			rtmpService.addSubscriberCameraStream(roomModel.getRoom().roomID, streamModel.subscriberCameraStreamID);
		}
	}
}