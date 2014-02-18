package com.andrievsky.videoconference.controller
{	
	import com.andrievsky.videoconference.event.MainEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command
	{
		[Inject]
		public var scopeModel:ScopeModel;
		
		override public function execute():void
		{
			scopeModel.init();
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOGIN_STATE));
		}
	}
}