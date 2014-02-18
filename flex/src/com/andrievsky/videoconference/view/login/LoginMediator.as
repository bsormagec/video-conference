package com.andrievsky.videoconference.view.login
{
	import com.andrievsky.videoconference.event.LoadingEvent;
	import com.andrievsky.videoconference.event.LoginEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.vo.UserVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LoginMediator extends Mediator
	{
		[Inject]
		public var view:LoginView;
		
		[Inject]
		public var scopeModel:ScopeModel;
		
		override public function onRegister():void
		{
			view.loginButton.addEventListener(MouseEvent.CLICK, loginClickHandler); 
			scopeModel.users.source = scopeModel.getDumpUsers();
			view.dataProvider = scopeModel.users;
		}
		
		private function loginClickHandler(event:MouseEvent):void
		{
			dispatch(new LoginEvent(LoginEvent.LOGIN, view.userList.selectedItem as UserVO));
		}
	}
}