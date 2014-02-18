package com.andrievsky.videoconference.model
{
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.model.vo.UserVO;
	import com.andrievsky.videoconference.service.rtmp.RTMPComposer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;

	public class RoomModel extends Actor
	{	
		private var room:RoomVO;
		
		public function getRoom():RoomVO
		{
			return room;
		}
		
		public function updateRoom(object:Object):void
		{
			// Basic Properties
			if (!this.room)
			{
				// Init
				this.room = new RoomVO(object.roomID, object.name);
				this.room.users = new ArrayCollection();
				this.room.messages = new ArrayCollection();
			}
			else
			{
				// Update
				this.room.roomID = object.roomID;
				this.room.roomName = object.name;
				this.room.users.removeAll();
				this.room.messages.removeAll();
			}
			// Type
			this.room.type = object.type;
			if (room.type == 1)
			{
				// Users
				for each(var i:Object in object.users)
				{
					addUser(i);
				}
			}
			else
			{
				// User
				this.room.user = RTMPComposer.getUser(object.user);
				// Subscriber Stream
				this.room.subscriberCameraStreamID = object.subscriberCameraStreamID;
			}
			
			// Caster Stream
			this.room.casterCameraStreamID = object.casterCameraStreamID;
			
			// Messages
			for each(i in object.messages)
			{
				addMessage(i);
			}
		}
		
		public function addUser(object:Object):void
		{
			if (room.type == 1)
			{
				this.room.users.addItem(RTMPComposer.getUser(object));
			}
			else
			{
				this.room.user = RTMPComposer.getUser(object);
			}
			
		}
		
		public function removeUser(id:String):void
		{
			if (room.type == 1)
			{
				for each(var user:UserVO in this.room.users)
				{
					if(user.userID == id){
						this.room.users.removeItemAt(this.room.users.getItemIndex(user));
						return;
					}
				}
			}
			else
			{
				this.room.user = null;
			}
			
		}
		
		public function addMessage(object:Object):void
		{
			this.room.messages.addItem(RTMPComposer.getMessage(object));
		}
		
		public function updateCasterCameraStream(object:Object):void
		{
			room.casterCameraStreamID = object as String;
		}
		
		public function updateSubscriberCameraStream(object:Object):void
		{
			room.subscriberCameraStreamID = object as String;
		}
		
		
		public function emptyRoom():void
		{
			if(this.room)
			{
				this.room.roomID = "";
				this.room.roomName = "";
				this.room.type = 0;
				this.room.casterCameraStreamID = null;
				this.room.subscriberCameraStreamID = null;
				this.room.users.removeAll();
				this.room.messages.removeAll();
			}
		}
	}
}