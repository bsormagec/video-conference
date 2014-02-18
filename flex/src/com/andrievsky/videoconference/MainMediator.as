package com.andrievsky.videoconference
{
	import com.andrievsky.videoconference.event.MainEvent;
	import com.andrievsky.videoconference.view.common.View;
	import com.andrievsky.videoconference.view.lobby.LobbyView;
	import com.andrievsky.videoconference.view.login.LoginView;
	import com.andrievsky.videoconference.view.privatecaster.PrivateCasterView;
	import com.andrievsky.videoconference.view.privatesubscriber.PrivateSubscriberView;
	import com.andrievsky.videoconference.view.publiccaster.PublicCasterView;
	import com.andrievsky.videoconference.view.publicsubscriber.PublicSubscriberView;
	
	import mx.states.State;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainMediator extends Mediator
	{
		[Inject]
		public var view:MainView;
		
		private var currentView:View;
		
		override public function onRegister():void
		{
			//this.eventMap.mapListener(this.stageModule, FlexEvent.CREATION_COMPLETE, this.creationCompleteHandler);
			trace("App Ready")
			this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_PUBLIC_CASTER_STATE, switchHandler);
			this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_PUBLIC_SUBSCRIBER_STATE, switchHandler);
			this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_LOGIN_STATE, switchHandler);
			this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_LOBBY_STATE, switchHandler);
			this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_PRIVATE_CASTER_STATE, switchHandler);
			this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_PRIVATE_SUBSCRIBER_STATE, switchHandler);
			
		}
		
		private function switchHandler(event:MainEvent):void
		{
			switch(event.type)
			{
				case MainEvent.SWITCH_TO_PUBLIC_CASTER_STATE :
					addView(new PublicCasterView());
					break;
				
				case MainEvent.SWITCH_TO_PUBLIC_SUBSCRIBER_STATE :
					addView(new PublicSubscriberView());
					break;
				
				case MainEvent.SWITCH_TO_LOGIN_STATE :
					addView(new LoginView());
					break;
				
				case MainEvent.SWITCH_TO_LOBBY_STATE :
					addView(new LobbyView());
					break;
				case MainEvent.SWITCH_TO_PRIVATE_CASTER_STATE :
					addView(new PrivateCasterView());
					break;
				case MainEvent.SWITCH_TO_PRIVATE_SUBSCRIBER_STATE :
					addView(new PrivateSubscriberView());
					break;
			}
		}
		
		private function addView(value:View):void
		{
			if (currentView)
			{
				view.container.removeElement(currentView);
			}
			currentView = value;
			view.container.addElement(currentView);
		}
	}
}