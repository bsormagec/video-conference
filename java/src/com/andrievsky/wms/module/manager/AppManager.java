package com.andrievsky.wms.module.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

import com.andrievsky.wms.module.model.RoomModel;
import com.andrievsky.wms.module.model.StackModel;
import com.andrievsky.wms.module.model.UserModel;
import com.andrievsky.wms.module.model.data.AbstractRoom;
import com.andrievsky.wms.module.model.data.ChatMessage;
import com.andrievsky.wms.module.model.data.PrivateRoom;
import com.andrievsky.wms.module.model.data.PublicRoom;
import com.andrievsky.wms.module.model.data.FeedbackComposer;
import com.andrievsky.wms.module.model.data.User;
import com.andrievsky.wms.module.util.AMFUtils;
import com.wowza.wms.amf.AMFDataObj;
import com.wowza.wms.client.IClient;

public class AppManager {

	private UserModel userModel = new UserModel();
	private RoomModel roomModel = new RoomModel();
	private StackModel stackModel = new StackModel();

	public AppManager() {
	}
	
	/***
	 * Server methods
	 */
	public AMFDataObj login(IClient client, String userID, String name, int type)
	{
		// logout exist user
		if (userModel.gettUser(userID) != null)
		{
			userModel.getClient(userID).shutdownClient();
			logout(userModel.getClient(userID));
		}
		// add new user
		userModel.addUser(userID, name, type, client);
		updateUserRoomList(userModel.gettUser(userID));
		return FeedbackComposer.resultAMF(userModel.gettUser(userID));
	}
	
	public AMFDataObj openPublicRoom(IClient client, String roomID, String roomName, ArrayList<String> declaredUserID)
	{
		User owner = userModel.getUser(client);
		if (owner == null) 
		{
			return FeedbackComposer.errorAMF("No such user", 2);
		}
		if (roomModel.getRoom(roomID) != null) 
		{
			return FeedbackComposer.errorAMF("Room ("+roomID+") already exist", 2);
		}
		if (roomModel.getRoom(owner) != null) 
		{
			return FeedbackComposer.errorAMF("You should close previous class to create new one", 2);
		}
		// add new class to model
		PublicRoom room = roomModel.addPublicRoom(roomID, roomName, owner, declaredUserID);
		// notify waiting users
		ArrayList<User> users = stackModel.getUsers(room.roomID);
		if(users != null)
		{
			for (User user : users)
			{
				if (roomModel.isUserDeclaredInRoom(room.roomID, user.userID))
				{
					roomModel.join(roomID, user);
				}
				else
				{
					// Update undeclared users
					sendToUser(user, RemoteClientMethods.ERROR, FeedbackComposer.errorAMF("Room ("+roomID+") has been opened but you was not declared as participant", 2));
				}
			}
		}
		// Empty room in stack
		stackModel.removeRoom(roomID);
		// Update room users
		sendToRoomUsers(room, RemoteClientMethods.OPEN_ROOM, FeedbackComposer.resultAMF(room));
		// Update all users
		updateUsersRoomList();
		//sendToUser(room.owner, RemoteClientMethods.OPEN_ROOM, room);
		return FeedbackComposer.resultAMF(room);
	}
	
	public AMFDataObj openPrivateRoom(IClient client, String roomID, String roomName, String declaredUserID)
	{
		User owner = userModel.getUser(client);
		if (owner == null) 
		{
			return FeedbackComposer.errorAMF("No such user", 1);
		}
		if (roomModel.getRoom(roomID) != null) 
		{
			return FeedbackComposer.errorAMF("Room ("+roomID+") already exist", 2);
		}
		if (roomModel.getRoom(owner) != null) 
		{
			return FeedbackComposer.errorAMF("You should close previous class to create new one", 2);
		}
		// add new class to model
		PrivateRoom room = roomModel.addPrivateRoom(roomID, roomName, owner, declaredUserID);
		// notify waiting users
		ArrayList<User> users = stackModel.getUsers(room.roomID);
		if(users != null)
		{
			for (User user : users)
			{
				if (roomModel.isUserDeclaredInRoom(room.roomID, user.userID))
				{
					roomModel.join(roomID, user);
				}
				else
				{
					// Update undeclared users
					sendToUser(user, RemoteClientMethods.ERROR, FeedbackComposer.errorAMF("Room ("+roomID+") has been opened but you was not declared as participant", 2));
				}
			}
		}
		// Empty room in stack
		stackModel.removeRoom(roomID);
		// Update room users
		sendToRoomUsers(room, RemoteClientMethods.OPEN_ROOM, FeedbackComposer.resultAMF(room));
		// Update all users
		updateUsersRoomList();
		//sendToUser(room.owner, RemoteClientMethods.OPEN_ROOM, room);
		return FeedbackComposer.resultAMF(room);
	}
	
	public AMFDataObj joinRoom(IClient client, String roomID)
	{
		User user = userModel.getUser(client);
		if (user.roomID != null) return FeedbackComposer.errorAMF("You're already joined to another room ("+user.roomID+")", 2);
		
		AbstractRoom room = roomModel.getRoom(roomID);
		// check room exist
		if (room != null)
		{
			if (!roomModel.isUserDeclaredInRoom(room.roomID, user.userID))
			{
				return FeedbackComposer.errorAMF("You're not allowed to join this room ("+room.roomID+")", 2);
			}
			// Update room users
			sendToAllRoomUsers(room, RemoteClientMethods.ADD_USER, FeedbackComposer.resultAMF(user));
			// Update room model
			roomModel.join(roomID, user);
		}
		else
		{
			stackModel.addUser(roomID, user);
		}
		return FeedbackComposer.resultAMF(room);
	}

		
	public AMFDataObj leaveRoom(IClient client, String roomID)
	{
		AbstractRoom room = roomModel.getRoom(roomID);
		// check room existence
		User user = userModel.getUser(client);
		// check room exist
		if (room != null)
		{
			if(!roomModel.isUserInRoom(user.roomID, user))
			{
				return FeedbackComposer.errorAMF("Operation with room ("+room.roomID+") not acceptable", 2);
			}
			// Update room model
			roomModel.leave(roomID, user);
			// Update room users
			sendToAllRoomUsers(room, RemoteClientMethods.REMOVE_USER, FeedbackComposer.resultAMF(user.userID));
		}
		else
		{
			stackModel.removeUser(roomID, user);
			if (stackModel.isEmptyRoom(roomID)) stackModel.removeRoom(roomID);
		}
		return FeedbackComposer.resultAMF(room);
	}
	
	public AMFDataObj closeRoom(IClient client, String roomID)
	{
		AbstractRoom room = roomModel.getRoom(roomID);
		// check room exist
		if (room == null) return FeedbackComposer.errorAMF("There is no room ("+roomID+") to close", 2);
		if (room.owner != userModel.getUser(client)) return FeedbackComposer.errorAMF("You have no permission to close the room ("+roomID+")", 2);
		removeRoom(room);
		updateUsersRoomList();
		return FeedbackComposer.resultAMF(true);
	}
	
	public AMFDataObj logout(IClient client)
	{
		User user = userModel.getUser(client);
		if (user == null) return FeedbackComposer.errorAMF("There's no such user", 1);
		AbstractRoom room = roomModel.getRoom(user);
		
		// if user has own room close it
		if (room != null)
		{
			closeRoom(client, room.roomID);
		}
		else
		{
			// TODO: Replace User.roomID property logic
			// if user has a room
			if(user.roomID != null)
			{
				leaveRoom(client, user.roomID);
			}
		}
		userModel.removetUser(user.userID);
		return FeedbackComposer.resultAMF(true);
	}
	
	public AMFDataObj addCasterCameraStream(IClient client, String roomID, String streamID)
	{
		AbstractRoom room = roomModel.getRoom(roomID);
		// check room exist
		if (room == null) return FeedbackComposer.errorAMF("There is no room ("+roomID+")", 1);
		if (room.owner != userModel.getUser(client)) return FeedbackComposer.errorAMF("You have no permission to stream for the room ("+roomID+")", 1);
		room.casterCameraStreamID = streamID;
		sendToRoomUsers(room, RemoteClientMethods.UPDATE_CASTER_CAMERA_STREAM, FeedbackComposer.resultAMF(room.casterCameraStreamID));
		return FeedbackComposer.resultAMF(room.casterCameraStreamID);
	}
	
	public AMFDataObj addSubscriberCameraStream(IClient client, String roomID, String streamID)
	{
		AbstractRoom room = roomModel.getRoom(roomID);
		// check room exist
		if (room == null) return FeedbackComposer.errorAMF("There is no room ("+roomID+")", 1);
		if (room.type != 2) return FeedbackComposer.errorAMF("Wrong room type ("+roomID+")", 1);
		if (!roomModel.isUserInRoom(roomID, userModel.getUser(client))) return FeedbackComposer.errorAMF("You have no permission to stream for the room ("+roomID+")", 1);
		((PrivateRoom) room).subscriberCameraStreamID = streamID;
		sendToUser(room.owner, RemoteClientMethods.UPDATE_SUBSCRIBER_CAMERA_STREAM, FeedbackComposer.resultAMF(streamID));
		return FeedbackComposer.resultAMF(streamID);
	}
	
	public AMFDataObj addMessage(IClient client, String roomID, String content)
	{
		AbstractRoom room = roomModel.getRoom(roomID);
		if (room == null) return FeedbackComposer.errorAMF("There is no room ("+roomID+")", 1);
		User user = userModel.getUser(client);
		if (user == null) return FeedbackComposer.errorAMF("There's no such user", 1);
		
		if(roomModel.isUserInRoom(room.roomID, user) || roomModel.isUserRoomOwner(room.roomID, user))
		{
			ChatMessage message = roomModel.addMessage(roomID, user, content);
			sendToAllRoomUsers(room, RemoteClientMethods.MESSAGE, FeedbackComposer.resultAMF(message));
		}
		else
		{
			return FeedbackComposer.errorAMF("You are not joined to the room ("+roomID+")", 1);
		}
		return FeedbackComposer.resultAMF(true);
	}
	
	/***
	 * Internal methods
	 */
	private void removeRoom(AbstractRoom room)
	{
		sendToRoomUsers(room, RemoteClientMethods.CLOSE_ROOM, FeedbackComposer.resultAMF(room.roomID));
		roomModel.removeRoom(room.roomID);
	}

	/***
	 * Client Side Methods
	 */
	private void sendToUser(User user, String command, Object params)
	{
		userModel.getClient(user.userID).call(command, null, params);
		//userModel.getClient(user.userID).call(command, null, params);
	}
	
	private void sendToUsers(ArrayList<User> users, String command, Object params)
	{
		for (User user : users)
		{
			sendToUser(user, command, params);
		}
	}
	
	private void sendToAllUsers(String command, Object params)
	{
		for (User user : userModel.getAllUsers())
		{
			sendToUser(user, command, params);
		}
	}
	
	private void updateUserRoomList(User user)
	{
		sendToUser(user, RemoteClientMethods.UPDATE_ROOM_LIST, FeedbackComposer.resultAMF(roomModel.getAllRooms()));
	}
	
	private void updateUsersRoomList()
	{
		sendToAllUsers(RemoteClientMethods.UPDATE_ROOM_LIST, FeedbackComposer.resultAMF(roomModel.getAllRooms()));
	}
	
	private void sendToRoomUsers(AbstractRoom room, String command, Object params)
	{
		if (room instanceof PublicRoom)
		{
			sendToUsers(((PublicRoom) room).users, command, params);
		}
		else
		{
			if(((PrivateRoom) room).user != null) sendToUser(((PrivateRoom) room).user, command, params);
		}
	}
	
	private void sendToAllRoomUsers(AbstractRoom room, String command, Object params)
	{
		sendToRoomUsers(room, command, params);
		sendToUser(room.owner, command, params);
	}
	
	/***
	 * debug
	 */
	public String debug()
	{
		return 	"UserModel "+"\n"+
				userModel+"\n"+
				"RoomModel "+"\n"+
				roomModel+"\n"+
				"StackModel "+"\n"+
				stackModel;
	}
	
	public AMFDataObj toObject()
	{
		AMFDataObj data = new AMFDataObj();
		data.put("users", AMFUtils.encodeCustomObject(userModel.toObject()));
		data.put("rooms", AMFUtils.encodeCustomObject(roomModel.toObject()));
		data.put("stack", AMFUtils.encodeCustomObject(stackModel.toObject()));
		return data;
	}

}
