package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.StreamModel;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import org.robotlegs.mvcs.Command;
	
	public class LeaveRoomCommand extends Command
	{
		[Inject]
		public var streamModel:StreamModel;
		[Inject]
		public var rtmpService:RTMPService;
		[Inject]
		public var roomModel:RoomModel;
		
		override public function execute():void
		{
			if (roomModel.getRoom().type == 2) streamModel.closeStream(roomModel.getRoom().subscriberCameraStreamID);
			rtmpService.leaveRoom(roomModel.getRoom().roomID);
		}
	}
}