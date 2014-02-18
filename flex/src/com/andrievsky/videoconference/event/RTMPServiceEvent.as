package com.andrievsky.videoconference.event
{
	import flash.events.Event;
	
	public class RTMPServiceEvent extends Event
	{
		/***
		 * Commands
		 */
		public static const ADD_PUBLIC_ROOM:String = "RTMPServiceEvent.ADD_PUBLIC_ROOM";
		public static const ADD_PRIVATE_ROOM:String = "RTMPServiceEvent.ADD_PRIVATE_ROOM";
		public static const JOIN_ROOM:String = "RTMPServiceEvent.JOIN_ROOM";
		public static const LEAVE_ROOM:String = "RTMPServiceEvent.LEAVE_ROOM";
		public static const CLOSE_ROOM:String = "RTMPServiceEvent.CLOSE_ROOM";
		public static const ADD_CASTER_CAMERA_STREAM:String = "RTMPServiceEvent.ADD_CASTER_CAMERA_STREAM";
		public static const ADD_SUBSCRIBER_CAMERA_STREAM:String = "RTMPServiceEvent.ADD_SUBSCRIBER_CAMERA_STREAM";
		public static const CREATE_CASTER_CAMERA_STREAM:String = "RTMPServiceEvent.CREATE_CASTER_CAMERA_STREAM";
		public static const CREATE_SUBSCRIBER_CAMERA_STREAM:String = "RTMPServiceEvent.CREATE_SUUBSCRIBER_CAMERA_STREAM";
		public static const ADD_MESSAGE:String = "RTMPServiceEvent.ADD_MESSAGE";
		public static const MUTE_CASTER_CAMERA_STREAM:String = "RTMPServiceEvent.MUTE_CASTER_CAMERA_STREAM";
		public static const UNMUTE_CASTER_CAMERA_STREAM:String = "RTMPServiceEvent.UNMUTE_CASTER_CAMERA_STREAM";
		public static const SHOW_CASTER_CAMERA_STREAM:String = "RTMPServiceEvent.SHOW_CASTER_CAMERA_STREAM";
		public static const HIDE_CASTER_CAMERA_STREAM:String = "RTMPServiceEvent.HIDE_CASTER_CAMERA_STREAM";
		
		public var data:* = null;
		
		public function RTMPServiceEvent(type:String, data:*=null)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}