package com.andrievsky.videoconference
{
	import com.andrievsky.videoconference.controller.AddCasterCameraStreamCommand;
	import com.andrievsky.videoconference.controller.AddMessageCommand;
	import com.andrievsky.videoconference.controller.AddPrivateRoomCommand;
	import com.andrievsky.videoconference.controller.AddPublicRoomCommand;
	import com.andrievsky.videoconference.controller.AddSubscriberCameraStreamCommand;
	import com.andrievsky.videoconference.controller.CloseRoomCommand;
	import com.andrievsky.videoconference.controller.CreateCasterCameraStreamCommand;
	import com.andrievsky.videoconference.controller.CreateSubscriberCameraStreamCommand;
	import com.andrievsky.videoconference.controller.HideCasterCameraStreamCommand;
	import com.andrievsky.videoconference.controller.JoinRoomCommand;
	import com.andrievsky.videoconference.controller.LeaveRoomCommand;
	import com.andrievsky.videoconference.controller.LoadingCompleteCommand;
	import com.andrievsky.videoconference.controller.LoginCommand;
	import com.andrievsky.videoconference.controller.LogoutCommand;
	import com.andrievsky.videoconference.controller.MuteCasterCameraStreamCommand;
	import com.andrievsky.videoconference.controller.ShowCasterCameraStreamCommand;
	import com.andrievsky.videoconference.controller.StartupCommand;
	import com.andrievsky.videoconference.controller.UnmuteCasterCameraStreamCommand;
	import com.andrievsky.videoconference.event.LoadingEvent;
	import com.andrievsky.videoconference.event.LoginEvent;
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ConfigModel;
	import com.andrievsky.videoconference.model.FullScreenModel;
	import com.andrievsky.videoconference.model.GraphicModel;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.StreamModel;
	import com.andrievsky.videoconference.service.http.HTTPService;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	import com.andrievsky.videoconference.view.common.chat.ChatMediator;
	import com.andrievsky.videoconference.view.common.chat.ChatView;
	import com.andrievsky.videoconference.view.loading.LoadingMediator;
	import com.andrievsky.videoconference.view.loading.LoadingView;
	import com.andrievsky.videoconference.view.lobby.LobbyMediator;
	import com.andrievsky.videoconference.view.lobby.LobbyView;
	import com.andrievsky.videoconference.view.login.LoginMediator;
	import com.andrievsky.videoconference.view.login.LoginView;
	import com.andrievsky.videoconference.view.privatecaster.PrivateCasterMediator;
	import com.andrievsky.videoconference.view.privatecaster.PrivateCasterView;
	import com.andrievsky.videoconference.view.privatesubscriber.PrivateSubscriberMediator;
	import com.andrievsky.videoconference.view.privatesubscriber.PrivateSubscriberView;
	import com.andrievsky.videoconference.view.profile.ProfileMediator;
	import com.andrievsky.videoconference.view.profile.ProfileView;
	import com.andrievsky.videoconference.view.publiccaster.PublicCasterMediator;
	import com.andrievsky.videoconference.view.publiccaster.PublicCasterView;
	import com.andrievsky.videoconference.view.publicsubscriber.PublicSubscriberMediator;
	import com.andrievsky.videoconference.view.publicsubscriber.PublicSubscriberView;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class MainContext extends Context
	{
		
		override public function startup():void
		{
			
			/***
			 *  Controller
			 */
			commandMap.mapEvent( ContextEvent.STARTUP, StartupCommand, ContextEvent, true );
			commandMap.mapEvent( LoadingEvent.LOADING_COMPLETE, LoadingCompleteCommand, LoadingEvent);
			commandMap.mapEvent(LoginEvent.LOGIN, LoginCommand, LoginEvent);
			commandMap.mapEvent(LoginEvent.LOGOUT, LogoutCommand, LoginEvent);
			commandMap.mapEvent(RTMPServiceEvent.ADD_PUBLIC_ROOM, AddPublicRoomCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.CLOSE_ROOM, CloseRoomCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.JOIN_ROOM, JoinRoomCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.LEAVE_ROOM, LeaveRoomCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.ADD_MESSAGE, AddMessageCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.ADD_PRIVATE_ROOM, AddPrivateRoomCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.ADD_CASTER_CAMERA_STREAM, AddCasterCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.CREATE_CASTER_CAMERA_STREAM, CreateCasterCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.ADD_SUBSCRIBER_CAMERA_STREAM, AddSubscriberCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.CREATE_SUBSCRIBER_CAMERA_STREAM, CreateSubscriberCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.MUTE_CASTER_CAMERA_STREAM, MuteCasterCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.UNMUTE_CASTER_CAMERA_STREAM, UnmuteCasterCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.SHOW_CASTER_CAMERA_STREAM, ShowCasterCameraStreamCommand, RTMPServiceEvent);
			commandMap.mapEvent(RTMPServiceEvent.HIDE_CASTER_CAMERA_STREAM, HideCasterCameraStreamCommand, RTMPServiceEvent);
			
			/***
			 *  Model
			 */
			injector.mapSingleton(ConfigModel);
			injector.mapSingleton(ScopeModel);
			injector.mapSingleton(RoomModel);
			injector.mapSingleton(StreamModel);
			injector.mapSingleton(GraphicModel);
			injector.mapSingleton(FullScreenModel);
			
			/***
			 * Services
			 */
			injector.mapSingleton(RTMPService);
			injector.mapSingleton(HTTPService);

			
			/***
			 * View
			 */
			mediatorMap.mapView(MainView, MainMediator, null, true, false);
			mediatorMap.mapView(LoginView, LoginMediator);
			mediatorMap.mapView(LobbyView, LobbyMediator);
			mediatorMap.mapView(PublicCasterView, PublicCasterMediator);
			mediatorMap.mapView(PublicSubscriberView, PublicSubscriberMediator);
			mediatorMap.mapView(ProfileView, ProfileMediator, null, true, false);
			mediatorMap.mapView(ChatView, ChatMediator);
			mediatorMap.mapView(PrivateCasterView, PrivateCasterMediator);
			mediatorMap.mapView(PrivateSubscriberView, PrivateSubscriberMediator);
			
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}