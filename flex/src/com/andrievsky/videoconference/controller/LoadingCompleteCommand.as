package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.LoadingEvent;
	import com.andrievsky.videoconference.event.MainEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.service.http.HTTPService;
	import com.andrievsky.videoconference.view.publiccaster.PublicCasterView;
	import com.andrievsky.videoconference.view.loading.LoadingView;
	
	import org.robotlegs.mvcs.Command;
	
	public class LoadingCompleteCommand extends Command
	{
		[Inject]
		public var scopeModel:ScopeModel;
		
		[Inject]
		public var httpService:HTTPService;
		
		[Inject]
		public var event:LoadingEvent;
		
		override public function execute():void
		{
			if (scopeModel.declaredComponents.indexOf(Object(event.data).constructor) == -1)
			{
				scopeModel.loadedcomponents.push(event.data);
				return;
			}
			scopeModel.loadedcomponents.push(event.data);
			if (scopeModel.declaredComponents.length != scopeModel.loadedcomponents.length) return;
			letsGO();
		}
		
		private function letsGO():void
		{
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOGIN_STATE));
		}
	}
}