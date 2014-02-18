package com.andrievsky.wms.module.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import com.andrievsky.wms.module.model.data.AbstractRoom;
import com.andrievsky.wms.module.model.data.ChatMessage;
import com.andrievsky.wms.module.model.data.PrivateRoom;
import com.andrievsky.wms.module.model.data.PublicRoom;
import com.andrievsky.wms.module.model.data.User;
import com.andrievsky.wms.module.util.PairKeyMap;

public class RoomModel {
	private PairKeyMap<User, String, AbstractRoom> rooms = new PairKeyMap<User, String, AbstractRoom>();

	public RoomModel() {
	}
	
	public PublicRoom addPublicRoom(String roomID, String name, User owner, ArrayList<String> declaredUsersID)
	{
		PublicRoom room = new PublicRoom();
		room.owner = owner;
		room.name = name;
		room.declaredUsersID = declaredUsersID;
		room.roomID = roomID;
		rooms.put(room.owner, room.roomID, room);
		return room;
	}
	
	public PrivateRoom addPrivateRoom(String roomID, String name, User owner, String declaredUserID)
	{
		PrivateRoom room = new PrivateRoom();
		room.owner = owner;
		room.name = name;
		room.declaredUserID = declaredUserID;
		room.roomID = roomID;
		rooms.put(room.owner, room.roomID, room);
		return room;
	}
	
	public AbstractRoom getRoom(User owner)
	{
		return rooms.getK1(owner);
	}
	
	public AbstractRoom getRoom(String roomID)
	{
		return rooms.getK2(roomID);
	}
	
	public List<AbstractRoom> getAllRooms()
	{
		return rooms.getValues();
	}
	
	public void removeRoom(String roomID)
	{
		// clean roomID
		AbstractRoom room = getRoom(roomID);
		if (room instanceof PublicRoom)
		{
			for (User user : ((PublicRoom) room).users)
			{
				user.roomID = null;
			}
		}
		else
		{
			if (((PrivateRoom) room).user != null) ((PrivateRoom) room).user.roomID = null;
		}
		// remove room
		rooms.removeK2(roomID);
	}
	
	public void removeRoom(User owner)
	{
		rooms.removeK1(owner);
	}
	
	public void join(String roomID, User user)
	{
		user.roomID = roomID;
		AbstractRoom room = getRoom(roomID);
		if (room instanceof PublicRoom)
		{
			((PublicRoom) room).users.add(user);
		}
		else
		{
			((PrivateRoom) room).user = user;
		}
	}
	
	public void leave(String roomID, User user)
	{
		user.roomID = null;
		AbstractRoom room = getRoom(roomID);
		if (room instanceof PublicRoom)
		{
			((PublicRoom) room).users.remove(user);
		}
		else
		{
			((PrivateRoom) room).user = null;
		}
	}
	
	public ChatMessage addMessage(String roomID, User user, String content)
	{ 
		AbstractRoom room = getRoom(roomID);
		ChatMessage message = new ChatMessage();
		message.userName = user.userName;
		message.content = content;
		message.timeStamp = new Date();
		message.messageID = UUID.randomUUID().toString();
		room.messages.add(message);
		return message;
	}
	
	public boolean isUserInRoom(String roomID, User user)
	{
		AbstractRoom room = getRoom(roomID);
		if (room instanceof PublicRoom)
		{
			return ((PublicRoom) room).users.contains(user);
		}
		else
		{
			return ((PrivateRoom) room).user == user;
		}
	}
	
	public boolean isUserDeclaredInRoom(String roomID, String userID)
	{
		AbstractRoom room = getRoom(roomID);
		if (room instanceof PublicRoom)
		{
			return ((PublicRoom) room).declaredUsersID.contains(userID);
		}
		else
		{
			return ((PrivateRoom) room).declaredUserID.equals(userID);
		}
	}
	
	public boolean isUserRoomOwner(String roomID, User user)
	{
		AbstractRoom room = getRoom(roomID);
		return room.owner == user;
	}
	
	public String toString()
	{
		return rooms.toString();
	}
	
	public Object toObject()
	{
		return rooms.toObject();
	}

}
