package com.andrievsky.wms.module.model.data;

import java.util.ArrayList;

public class AbstractRoom {

	public String roomID;
	public User owner;
	public String name;
	public int type;
	public String casterCameraStreamID;
	public String casterDesktopStreamID;
	public ArrayList<ChatMessage> messages = new ArrayList<ChatMessage>();
	
	public AbstractRoom() {
		// TODO Auto-generated constructor stub
	}
	
	public String toString()
	{
		return roomID+", "+name+", "+owner;
	}

}
