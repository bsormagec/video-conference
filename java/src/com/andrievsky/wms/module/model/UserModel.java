package com.andrievsky.wms.module.model;

import java.util.Collection;

import com.andrievsky.wms.module.model.data.User;
import com.andrievsky.wms.module.util.PairKeyMap;
import com.wowza.wms.amf.AMFDataObj;
import com.wowza.wms.client.IClient;

public class UserModel {

	private PairKeyMap<IClient, String, User> users = new PairKeyMap<IClient, String, User>();
	
	public UserModel() {
		// TODO Auto-generated constructor stub
	}
	
	public void addUser(String userID, String name, int type, IClient client)
	{
		User rawUser = new User();
		rawUser.userID = userID;
		rawUser.userName = name;
		rawUser.type = type;
		users.put(client, rawUser.userID, rawUser);
	}
	
	public User gettUser(String userID)
	{
		return users.getK2(userID);
	}
	
	public User getUser(IClient client)
	{
		return users.getK1(client);
	}
	
	public IClient getClient(String userID)
	{
		return users.getKeyK1K2(userID);
	}
	
	public Collection<User> getAllUsers()
	{
		return users.getValues();
	}
	
	public Collection<IClient> getAllClients()
	{
		return users.getK1Values();
	}
	
	public void removetUser(String userID)
	{
		users.removeK2(userID);
	}

	public String toString()
	{
		return users.toString();
	}
	
	public Object toObject()
	{
		return users.toObject();
	}

}
