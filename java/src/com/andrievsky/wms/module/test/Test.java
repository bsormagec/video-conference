package com.andrievsky.wms.module.test;

import java.util.ArrayList;

import com.andrievsky.wms.module.SkillstrModule;
import com.andrievsky.wms.module.manager.AppManager;
import com.wowza.wms.amf.AMFDataArray;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.client.IClient;
import com.wowza.wms.request.RequestFunction;

public class Test {
	
	public AppManager manager = new AppManager();
	
	public Test() {
		// TODO Auto-generated constructor stub
	}
	
	public void start()
	{
		System.out.println("start test");
		//scenario1();
		//test1();
	}
	
	public void scenario1()
	{
		//client 1
		IClient client1 = new StubClient();
		System.out.println(manager.login(client1, "userID_1", "userName_1", 1));
		ArrayList<String> declaredUsers = new ArrayList<String>();
		declaredUsers.add("userID_2"); declaredUsers.add("userID_6"); declaredUsers.add("userID_7");
		System.out.println(manager.openPublicRoom(client1, "roomID_1", "roomName_1", declaredUsers));
	}
	
	private void test1()
	{
		System.out.println("==================== test 1 ==================== ");
		//client 1
		IClient client1 = new StubClient();
		//client 2
		IClient client2 = new StubClient();
		//client 3
		IClient client3 = new StubClient();
		//client 4
		IClient client4 = new StubClient();
		//client 5
		IClient client5 = new StubClient();
		//client 6
		IClient client6 = new StubClient();
		//client 7
		IClient client7 = new StubClient();

		//login 1
		System.out.println("==================== login 1 ==================== ");
		System.out.println(manager.login(client1, "userID_1", "userName_1", 1));
		result();
		//login 2
		System.out.println("==================== login 2 ==================== ");
		System.out.println(manager.login(client2, "userID_2", "userName_2", 1));
		result();
		//login 3
		System.out.println("==================== login 3 ==================== ");
		System.out.println(manager.login(client3, "userID_1", "userName_3", 1));
		result();
		//login 4
		System.out.println("==================== login 4 ==================== ");
		System.out.println(manager.login(client4, "userID_4", "userName_4", 1));
		result();
		//login 5
		System.out.println("==================== login 5 ==================== ");
		System.out.println(manager.login(client5, "userID_5", "userName_5", 1));
		result();
		// join 5
		System.out.println("==================== join 5 ==================== ");
		System.out.println(manager.joinRoom(client5, "roomID_1"));
		result();
		// leave 5
		System.out.println("==================== leave 5 ==================== ");
		System.out.println(manager.leaveRoom(client5, "roomID_1"));
		result();
		// join 5
		System.out.println("==================== join 5 ==================== ");
		System.out.println(manager.joinRoom(client5, "roomID_1"));
		result();

		System.out.println("==================== login 6 ==================== ");
		System.out.println(manager.login(client6, "userID_6", "userName_6", 1));
		result();

		System.out.println("==================== join 6 ==================== ");
		System.out.println(manager.joinRoom(client6, "roomID_1"));
		result();
		
		//open public room 1
		System.out.println("==================== open public room 1 ==================== ");
		ArrayList<String> declaredUsers = new ArrayList<String>();
		declaredUsers.add("userID_2"); declaredUsers.add("userID_6"); declaredUsers.add("userID_7");
		System.out.println(manager.openPublicRoom(client3, "roomID_1", "roomName_1", declaredUsers));
		result();
		
		// again try to open public room 1
		System.out.println("==================== again try to open public room 1 ==================== ");
		declaredUsers = new ArrayList<String>();
		declaredUsers.add("userID_2"); declaredUsers.add("userID_6"); declaredUsers.add("userID_7");
		System.out.println(manager.openPublicRoom(client3, "roomID_1", "roomName_1", declaredUsers));
		result();
		
		
		System.out.println("==================== join 2 ==================== ");
		System.out.println(manager.joinRoom(client2, "roomID_1"));
		result();
		System.out.println("==================== join 4 ==================== ");
		System.out.println(manager.joinRoom(client4, "roomID_1"));
		result();
		System.out.println("==================== join 6 ==================== ");
		System.out.println(manager.joinRoom(client6, "roomID_1"));
		result();
		System.out.println("==================== leave 6 ==================== ");
		System.out.println(manager.leaveRoom(client6, "roomID_1"));
		result();
		System.out.println("==================== login 7 ==================== ");
		System.out.println(manager.login(client7, "userID_7", "userName_7", 2));
		result();
		System.out.println("==================== join 7 ==================== ");
		System.out.println(manager.joinRoom(client7, "roomID_1"));
		result();
		System.out.println("==================== join 7 try to join room 2 ==================== ");
		System.out.println(manager.joinRoom(client7, "roomID_2"));
		result();
		
		// try to close public room 1
		System.out.println("==================== try to close public room 1 ==================== ");
		System.out.println(manager.closeRoom(client7, "roomID_1"));
	
		/*
		// close public room 1
		System.out.println("==================== close public room 1 ==================== ");
		System.out.println(manager.closeRoom(client3, "roomID_1"));
		result();
		*/
	}
	
	private void result()
	{
		System.out.println("==================== result ==================== ");
		System.out.println(manager.debug());
	}
}
