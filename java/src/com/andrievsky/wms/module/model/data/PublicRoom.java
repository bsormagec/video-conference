package com.andrievsky.wms.module.model.data;

import java.util.ArrayList;

public class PublicRoom extends AbstractRoom {
	public ArrayList<User> users = new ArrayList<User>();
	public ArrayList<String> declaredUsersID = new ArrayList<String>();
	
	public PublicRoom() {
		type = 1;
	}

	public String toString()
	{
		return users +", " + declaredUsersID +", " +super.toString();
	}
	
}
