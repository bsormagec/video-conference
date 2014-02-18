package com.andrievsky.wms.module.model.data;

public class PrivateRoom extends AbstractRoom {
	
	public User user;
	public String declaredUserID;
	public String subscriberCameraStreamID;

	public PrivateRoom() {
		type = 2;
	}

	public String toString()
	{
		return user +", " + declaredUserID +", " +super.toString();
	}

}
