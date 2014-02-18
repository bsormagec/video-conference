package com.andrievsky.wms.module.model.data;

public class User {
	
	public String userID;
	public String userName;
	public int type;
	public String roomID;

	public User() {
		// TODO Auto-generated constructor stub
	}
	
	public String toString()
	{
		return userID+", "+userName+", "+type;
	}
}
