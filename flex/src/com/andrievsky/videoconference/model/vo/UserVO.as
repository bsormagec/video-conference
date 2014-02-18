package com.andrievsky.videoconference.model.vo
{
	[Bindable]
	public class UserVO
	{
		public var userID:String;
		public var userName:String;
		public var streamID:String;
		
		public function UserVO(userID:String, userName:String)
		{
			this.userID = userID;
			this.userName = userName;
		}
	}
}