package com.andrievsky.videoconference.model.vo
{
	import mx.collections.ArrayCollection;

	public class RoomVO
	{
		public var type:int;
		public var roomID:String;
		[Bindable]
		public var roomName:String;
		public var declaredUsersID:Array;
		public var declaredUserID:String;
		public var joinedUsers:Array;
		[Bindable]
		public var users:ArrayCollection;
		[Bindable]
		public var user:UserVO;
		[Bindable]
		public var casterCameraStreamID:String;
		[Bindable]
		public var subscriberCameraStreamID:String;
		[Bindable]
		public var messages:ArrayCollection;
		
		public function RoomVO(roomID:String=null, roomName:String=null)
		{
			this.roomID = roomID;
			this.roomName = roomName;
		}
	}
}