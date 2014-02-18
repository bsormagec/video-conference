package com.andrievsky.videoconference.service.rtmp
{
	import com.andrievsky.videoconference.model.vo.ChatMessageVO;
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.model.vo.UserVO;

	public class RTMPComposer
	{
		public static function getUser(object:Object):UserVO
		{
			if (!object) return null;
			return new UserVO(object.userID, object.userName);
		}
		
		public static function getRoom(object:Object):RoomVO
		{
			var room:RoomVO = new RoomVO(object.roomID, object.name);
			room.type = object.type;
			return room;
		}
		
		public static function getMessage(object:Object):ChatMessageVO
		{
			var value:ChatMessageVO = new ChatMessageVO();
			value.userName = object.userName;
			value.content = object.content;
			value.timeStamp = object.timeStamp;
			value.messageID = object.messageID;
			return value;
		}
	}
}