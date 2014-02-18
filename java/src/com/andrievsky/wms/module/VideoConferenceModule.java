package com.andrievsky.wms.module;
import com.andrievsky.wms.module.manager.AppManager;
import com.andrievsky.wms.module.test.Test;
import com.andrievsky.wms.module.util.ConvertUtil;
import com.wowza.wms.application.*;
import com.wowza.wms.amf.*;
import com.wowza.wms.client.*;
import com.wowza.wms.module.*;
import com.wowza.wms.request.*;
import com.wowza.wms.stream.*;

public class VideoConferenceModule extends ModuleBase {

	private AppManager manager = new AppManager();
	/***
	 * Server Side Methods
	 */
	public void login(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("login "+params.getString(PARAM2));
		sendResult(client, params, manager.login(client, params.getString(PARAM1), params.getString(PARAM2), params.getInt(PARAM3)));
	}
	
	public void logout(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("logout");
		sendResult(client, params, manager.logout(client));
	}
	
	public void addPublicRoom(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("addPublicRoom");
		sendResult(client, params, manager.openPublicRoom(client, params.getString(PARAM1), params.getString(PARAM2),
				ConvertUtil.AMFDataMixedArrayToArrayListString(getParamMixedArray(params, PARAM3))));
	}
	
	public void addPrivateRoom(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("addPrivateRoom");
		sendResult(client, params, manager.openPrivateRoom(client, params.getString(PARAM1), params.getString(PARAM2), params.getString(PARAM3)));
	}
	
	public void closeRoom(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("closeRoom");
		sendResult(client, params, manager.closeRoom(client, params.getString(PARAM1)));
	}
	
	public void joinRoom(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("joinRoom");
		sendResult(client, params, manager.joinRoom(client, params.getString(PARAM1)));
	}
	
	public void leaveRoom(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("leaveRoom");
		sendResult(client, params, manager.leaveRoom(client, params.getString(PARAM1)));
	}
	
	public void addMessage(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("addMessage");
		sendResult(client, params, manager.addMessage(client, params.getString(PARAM1), params.getString(PARAM2)));
	}
	
	public void addCasterCameraStream(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("addCameraStream");
		sendResult(client, params, manager.addCasterCameraStream(client, params.getString(PARAM1), params.getString(PARAM2)));
	}
	
	public void addSubscriberCameraStream(IClient client, RequestFunction function, AMFDataList params) 
	{
		getLogger().info("addSubscriberCameraStream");
		sendResult(client, params, manager.addSubscriberCameraStream(client, params.getString(PARAM1), params.getString(PARAM2)));
	}
	
	public void getDebugInfo(IClient client, RequestFunction function, AMFDataList params)
	{
		AMFDataObj data = manager.toObject();
		sendResult(client, params, data);
	}

	/***
	 * Handlers
	 */
	public void onAppStart(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStart: " + fullname);
		Test test = new Test();
		//test.manager = manager;
		//test.start();
	}

	public void onAppStop(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStop: " + fullname);
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("onConnect: " + client.getClientId());
	}

	public void onConnectAccept(IClient client) {
		getLogger().info("onConnectAccept: " + client.getClientId());
	}

	public void onConnectReject(IClient client) {
		getLogger().info("onConnectReject: " + client.getClientId());
	}

	public void onDisconnect(IClient client) {
		getLogger().info("onDisconnect: " + client.getClientId());
		manager.logout(client);
	}

	public void onStreamCreate(IMediaStream stream) {
		getLogger().info("onStreamCreate: " + stream.getSrc());
	}

	public void onStreamDestroy(IMediaStream stream) {
		getLogger().info("onStreamDestroy: " + stream.getSrc());
	}

	public void onCall(String handlerName, IClient client,
			RequestFunction function, AMFDataList params) {
		getLogger().info("onCall: " + handlerName);
	}

}