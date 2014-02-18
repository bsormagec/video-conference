package com.andrievsky.videoconference.view.common.chat
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.model.vo.ChatMessageVO;
	import com.andrievsky.videoconference.view.common.chat.ChatView;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	import spark.events.PopUpEvent;
	
	public class ChatMediator extends Mediator
	{
		
		[Inject]
		public var view:ChatView;
		
		[Inject]
		public var roomModel:RoomModel;
		
		[Inject]
		public var scopeModel:ScopeModel;

		override public function onRegister():void
		{
			view.addEventListener(RTMPServiceEvent.ADD_MESSAGE, sendMessageHandler);
			view.dataProvider = roomModel.getRoom().messages;
		}

		
		private function sendMessageHandler(event:RTMPServiceEvent):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.ADD_MESSAGE, event.data as String));
		}
	}
}