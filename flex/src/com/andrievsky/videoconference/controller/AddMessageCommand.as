package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddMessageCommand extends Command
	{
		[Inject]
		public var rtmpService:RTMPService;
		[Inject]
		public var event:RTMPServiceEvent;
		[Inject]
		public var roomModel:RoomModel;
		
		override public function execute():void
		{
			rtmpService.addMessage(roomModel.getRoom().roomID, event.data as String);
		}
	}
}