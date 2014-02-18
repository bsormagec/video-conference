package com.andrievsky.videoconference.event
{
	import com.andrievsky.videoconference.model.vo.UserVO;
	
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN:String = "LoginEvent.LOGIN";
		public static const LOGOUT:String = "LoginEvent.LOGOUT";
		public var user:UserVO;
		
		public function LoginEvent(type:String, user:UserVO=null)
		{
			this.user = user;
			super(type);
		}
	}
}