package com.andrievsky.videoconference.service.rtmp
{
	import com.andrievsky.videoconference.event.MainEvent;
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ConfigModel;
	import com.andrievsky.videoconference.model.GraphicModel;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.StreamModel;
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.model.vo.UserVO;
	
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.robotlegs.mvcs.Actor;
	
	public class RTMPService extends Actor
	{
		[Inject]
		public var configModel:ConfigModel;
		[Inject]
		public var scopeModel:ScopeModel;
		[Inject]
		public var roomModel:RoomModel;
		[Inject]
		public var streamModel:StreamModel;
		[Inject]
		public var graphicModel:GraphicModel;
		private var netConnection:NetConnection;
		
		public function connect():void
		{
			netConnection = new NetConnection();
			netConnection.client = this;
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			netConnection.connect(configModel.APPLICATION_PATH);
			scopeModel.connection = netConnection;
		}
		
		/***
		 * Server Methods
		 */
		
		public function login(user:UserVO):void
		{
			if(!netConnection)
			{
				connect();
				return;
			}
			scopeModel.logger.info("login "+user.userName);
			call("login", loginResponder, scopeModel.me.userID, scopeModel.me.userName, 1);
			graphicModel.lock();
		}	
		
		private function loginResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOBBY_STATE));
		}
		
		public function logout():void
		{
			scopeModel.logger.info("logout");
			call("logout", logoutResponder);
		}
		
		private function logoutResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOGIN_STATE));
			if (roomModel.getRoom() == null) return;
			roomModel.emptyRoom();
		}
		
		private function statusResponder(object:Object):void
		{
			Alert.show(object.toString());
			scopeModel.logger.error("statusResponder: "+object.toString());
		}
		
		public function addPublicRoom(roomID:String, roomName:String, declaredUserID:Array):void
		{
			scopeModel.logger.info("addPublicRoom "+roomID+", "+roomName+", "+declaredUserID);
			call("addPublicRoom", addPublicRoomResponder, roomID, roomName, declaredUserID);
		}
		
		private function addPublicRoomResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			roomModel.updateRoom(object.result);
			dispatch(new MainEvent(MainEvent.SWITCH_TO_PUBLIC_CASTER_STATE));
		}
		
		public function addPrivateRoom(roomID:String, roomName:String, declaredUserID:String):void
		{
			scopeModel.logger.info("addPrivateRoom "+roomID+", "+roomName+", "+declaredUserID);
			call("addPrivateRoom", addPrivateRoomResponder, roomID, roomName, declaredUserID);
		}
		
		private function addPrivateRoomResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			roomModel.updateRoom(object.result);
			dispatch(new MainEvent(MainEvent.SWITCH_TO_PRIVATE_CASTER_STATE));
		}
		
		public function closeRoom(roomID:String):void
		{
			if (roomModel.getRoom() == null) return;
			roomModel.emptyRoom();
			scopeModel.logger.info("closeRoom "+roomID);
			call("closeRoom", closeRoomResponder, roomID);
		}
		
		private function closeRoomResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOBBY_STATE));
		}
		
		public function joinRoom(room:RoomVO):void
		{
			scopeModel.logger.info("joinRoom "+room.roomID);
			call("joinRoom", joinRoomResponder, room.roomID);	
		}
		
		private function joinRoomResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			roomModel.updateRoom(object.result);
			if (roomModel.getRoom().type == 1)
			{
				dispatch(new MainEvent(MainEvent.SWITCH_TO_PUBLIC_SUBSCRIBER_STATE));
			}
			else
			{
				dispatch(new MainEvent(MainEvent.SWITCH_TO_PRIVATE_SUBSCRIBER_STATE));
			}
		}
		
		public function leaveRoom(roomID:String):void
		{
			if (roomModel.getRoom() == null) return;
			roomModel.emptyRoom();
			scopeModel.logger.info("leaveRoom "+roomID);
			call("leaveRoom", leaveRoomResponder, roomID);
		}
		
		private function leaveRoomResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOBBY_STATE));
		}
		
		public function addCasterCameraStream(roomID:String, streamID:String):void
		{
			scopeModel.logger.info("addCasterCameraStream "+roomID+", "+streamID);
			call("addCasterCameraStream", addCasterCameraStreamResponder, roomID, streamID);
		}
		
		private function addCasterCameraStreamResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			roomModel.updateCasterCameraStream(object.result);
		}
		
		public function addSubscriberCameraStream(roomID:String, streamID:String):void
		{
			scopeModel.logger.info("addSubscriberCameraStream "+roomID+", "+streamID);
			call("addSubscriberCameraStream", addSubscriberCameraStreamResponder, roomID, streamID);
		}

		private function addSubscriberCameraStreamResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
			roomModel.updateSubscriberCameraStream(object.result);
		}
		
		public function addMessage(roomID:String, content:String):void
		{
			scopeModel.logger.info("addMessage "+roomID+", "+content);
			call("addMessage", addMessageStreamResponder, roomID, content);
		}
		
		private function addMessageStreamResponder(object:Object):void
		{
			if(!checkFeedback(object)) return;
		}
		
		/***
		 * Client Methods
		 */
		public function onCloseRoom(data:Object):void
		{
			if(!checkFeedback(data)) return;
			dispatch(new MainEvent(MainEvent.SWITCH_TO_LOBBY_STATE));
		}
		public function openRoom(data:Object):void
		{
			if(!checkFeedback(data)) return;
			roomModel.updateRoom(data.result);
			dispatch(new MainEvent(MainEvent.SWITCH_TO_PUBLIC_CASTER_STATE));
		}
		public function updateRoomList(data:Object):void
		{
			if(!checkFeedback(data)) return;
			var rooms:Array = new Array();
			for each(var i:Object in data.result)
			{
				rooms.push(RTMPComposer.getRoom(i));
			}
			scopeModel.rooms.removeAll();
			scopeModel.rooms.source = rooms;
			scopeModel.rooms.refresh();
			//scopeModel.rooms = rooms;
		}
		public function addUser(data:Object):void
		{
			if(!checkFeedback(data)) return;
			roomModel.addUser(data.result);
		}
		public function removeUser(data:Object):void
		{
			if(!checkFeedback(data)) return;
			roomModel.removeUser(data.result as String);
		}
		public function message(data:Object):void
		{
			if(!checkFeedback(data)) return;
			roomModel.addMessage(data.result);
		}
		public function addStream(data:Object):void
		{
			
		}
		public function removeStream(data:Object):void
		{
			
		}
		public function error(data:Object):void
		{
			Alert.show("error: "+data);
		}
		
		public function close():void
		{
			Alert.show("You were disconnected from server");
		}
		
		public function updateCasterCameraStream(data:Object):void
		{
			if(!checkFeedback(data)) return;
			roomModel.updateCasterCameraStream(data.result);
		}
		
		public function updateSubscriberCameraStream(data:Object):void
		{
			if(!checkFeedback(data)) return;
			roomModel.updateSubscriberCameraStream(data.result);
		}
		
		
		/***
		 * NetConnection Handlers
		 */
		private function netStatusHandler(event:NetStatusEvent):void
		{
			scopeModel.logger.info("netConnection: "+event.info.code+" ("+event.info.description+")");
			if (event.info.code == "NetConnection.Connect.Success")
			{
				scopeModel.logger.info("NetConnection.Connect.Success");
				login(scopeModel.me);
			}
			else if (event.info.code == "NetConnection.Connect.Failed")
			{
				Alert.show("Server is not available");
				scopeModel.logger.error("Connection failed");
			}
			else if (event.info.code == "NetConnection.Connect.Rejected")
			{
				Alert.show("Server connection rejected");
				scopeModel.logger.error(event.info.description);
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			scopeModel.logger.error("securityErrorHandler: " + event);
		}
		
		
		/***
		 * Reuseable methods
		 */
		private function call(method:String, response:Function, ... params):void
		{
			//netConnection.call(method, new Responder(response, statusResponder), params);
			params.unshift(method, new Responder(response, statusResponder));
			netConnection.call.apply(this, params);
			if (method == "addMessage") return;
			graphicModel.lock();
		}
		
		private function checkFeedback(object:Object):Boolean
		{
			graphicModel.unlock();
			if(object.error)
			{
				Alert.show(object.error);
				return false;
			}
			if(!object.result)
			{
				Alert.show("Null server result");
				return false;
			}
			return true;
		}
	}
}