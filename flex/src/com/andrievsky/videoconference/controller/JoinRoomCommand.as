package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import org.robotlegs.mvcs.Command;
	
	public class JoinRoomCommand extends Command
	{
		[Inject]
		public var scopeModel:ScopeModel;
		[Inject]
		public var rtmpService:RTMPService;
		[Inject]
		public var event:RTMPServiceEvent;
		
		override public function execute():void
		{
			rtmpService.joinRoom(event.data as RoomVO);
		}
	}
}