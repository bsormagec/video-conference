package com.andrievsky.videoconference.view.profile
{
	import com.andrievsky.videoconference.event.LoginEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ProfileMediator extends Mediator
	{
		[Inject]
		public var view:ProfileView;
		
		[Inject]
		public var scopeModel:ScopeModel;
		
		override public function onRegister():void
		{
			this.eventMap.mapListener(this.eventDispatcher, LoginEvent.LOGIN, loginHandler);
			view.addEventListener(ProfileView.LOGOUT, logoutHandler);
			view.visible = false;
		}
		
		private function loginHandler(event:LoginEvent=null):void
		{
			view.visible = true;
			view.userName.text = event.user.userName;
		}
		
		private function logoutHandler(event:Event):void
		{
			view.visible = false;
			dispatch(new LoginEvent(LoginEvent.LOGOUT));
		}
	}
}