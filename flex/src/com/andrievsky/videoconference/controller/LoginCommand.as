package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.LoginEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoginCommand extends Command
	{
		[Inject]
		public var scopeModel:ScopeModel;
		[Inject]
		public var rtmpService:RTMPService;
		[Inject]
		public var event:LoginEvent;
		
		override public function execute():void
		{
			scopeModel.me = event.user;
			scopeModel.getDumpUsers().splice(scopeModel.getDumpUsers().indexOf(event.user), 1);
			rtmpService.login(scopeModel.me);
		}
	}
}