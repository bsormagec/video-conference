package com.andrievsky.wms.module.model;

import java.util.ArrayList;
import java.util.HashMap;

import com.andrievsky.wms.module.model.data.User;

public class StackModel {

	private HashMap<String, ArrayList<User>> waitingUsers = new HashMap<String, ArrayList<User>>();
	
	public StackModel() {
		// TODO Auto-generated constructor stub
	}
	
	public void addUser(String roomID, User user)
	{
		if (!waitingUsers.keySet().contains(roomID))
		{
			waitingUsers.put(roomID, new ArrayList<User>());
		}
		waitingUsers.get(roomID).add(user);
	}

	public void removeUser(String roomID, User user)
	{
		if (!waitingUsers.keySet().contains(roomID))
		{
			return;
		}
		if (waitingUsers.get(roomID).contains(user)) waitingUsers.get(roomID).remove(user);
	}
	
	public boolean isEmptyRoom(String roomID)
	{
		return (waitingUsers.get(roomID).size() == 0);
	}
	
	public void removeRoom(String roomID)
	{
		if (waitingUsers.keySet().contains(roomID)) waitingUsers.remove(roomID);
	}
	
	public ArrayList<User> getUsers(String roomID)
	{
		return waitingUsers.get(roomID);
	}
	
	public String toString()
	{
		return waitingUsers.toString();
	}
	
	public Object toObject()
	{
		return waitingUsers.values();
	}

}
