package com.andrievsky.videoconference.event
{
	import flash.events.Event;
	
	public class MainEvent extends Event
	{
		public static const SWITCH_TO_LOGIN_STATE:String = "MainEvent.SWITCH_TO_LOGIN_STATE";
		public static const SWITCH_TO_LOBBY_STATE:String = "MainEvent.SWITCH_TO_LOBBY_STATE";
		public static const SWITCH_TO_PUBLIC_CASTER_STATE:String = "MainEvent.SWITCH_TO_PUBLIC_CASTER_STATE";
		public static const SWITCH_TO_PUBLIC_SUBSCRIBER_STATE:String = "MainEvent.SWITCH_TO_PUBLIC_SUBSCRIBER_STATE";
		public static const SWITCH_TO_PRIVATE_CASTER_STATE:String = "MainEvent.SWITCH_TO_PRIVATE_CASTER_STATE";
		public static const SWITCH_TO_PRIVATE_SUBSCRIBER_STATE:String = "MainEvent.SWITCH_TO_PRIVATE_SUBSCRIBER_STATE";
		
		public function MainEvent(type:String)
		{
			super(type);
		}
	}
}