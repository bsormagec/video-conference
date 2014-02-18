package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.LoginEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.StreamModel;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import org.robotlegs.mvcs.Command;
	
	public class LogoutCommand extends Command
	{
		[Inject]
		public var scopeModel:ScopeModel;
		[Inject]
		public var rtmpService:RTMPService;
		[Inject]
		public var event:LoginEvent;
		[Inject]
		public var streamModel:StreamModel;
		
		override public function execute():void
		{
			streamModel.closeAllStreams();
			scopeModel.getDumpUsers().push(scopeModel.me);
			scopeModel.me = null;
			rtmpService.logout();
		}
	}
}