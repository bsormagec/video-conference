package com.andrievsky.videoconference.view.lobby
{
	import com.andrievsky.videoconference.event.LoadingEvent;
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.model.vo.UserVO;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.utils.UIDUtil;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class LobbyMediator extends Mediator
	{
		[Inject]
		public var view:LobbyView;
		
		[Inject]
		public var scopeModel:ScopeModel;
		
		override public function onRegister():void
		{
			//this.eventMap.mapListener(this.eventDispatcher, MainEvent.SWITCH_TO_LIBRARY_STATE, switchHandler);
			dispatch(new LoadingEvent(LoadingEvent.LOADING_COMPLETE, this.view));
			view.addPublicRoom.addEventListener(MouseEvent.CLICK, addPublicRoomHandler);
			view.addPrivateRoom.addEventListener(MouseEvent.CLICK, addPrivateRoomHandler);
			view.joinRoom.addEventListener(MouseEvent.CLICK, joinRoomHandler);
			view.users = scopeModel.users;
			view.rooms = scopeModel.rooms;
		}
		
		private function addPublicRoomHandler(event:MouseEvent):void
		{
			if (view.userList.selectedIndices.length == 0)
			{
				Alert.show("Please select room users");
				return;
			}
			var users:Array = new Array();
			for each(var user:UserVO in view.userList.selectedItems)
			{
				users.push(user.userID);
			}
			var room:RoomVO = new RoomVO(UIDUtil.createUID(), scopeModel.me.userName);
			room.declaredUsersID = users;
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.ADD_PUBLIC_ROOM, room));
		}
		
		private function addPrivateRoomHandler(event:MouseEvent):void
		{
			if (view.userList.selectedIndices.length == 0)
			{
				Alert.show("Please select room users");
				return;
			}
			if (view.userList.selectedIndices.length > 1)
			{
				Alert.show("You should select a single user for Private Class");
				return;
			}
			var room:RoomVO = new RoomVO(UIDUtil.createUID(), scopeModel.me.userName);
			room.declaredUserID = (view.userList.selectedItem as UserVO).userID;
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.ADD_PRIVATE_ROOM, room));
		}
		
		private function joinRoomHandler(event:MouseEvent):void
		{
			if (view.roomList.selectedItem == null)
			{
				Alert.show("Please select a room");
				return;
			}
			var room:RoomVO = view.roomList.selectedItem as RoomVO;
			
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.JOIN_ROOM, room));
		}
	}
}