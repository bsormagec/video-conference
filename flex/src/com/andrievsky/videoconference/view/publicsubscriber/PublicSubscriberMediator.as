package com.andrievsky.videoconference.view.publicsubscriber
{	
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ConfigModel;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.view.common.StreamMediator;
	import com.andrievsky.videoconference.view.common.StreamView;
	import com.andrievsky.videoconference.view.publiccaster.PublicCasterView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	import org.osmf.net.StreamType;
	import org.robotlegs.mvcs.Mediator;

	public class PublicSubscriberMediator extends StreamMediator
	{
		[Inject]
		public var view:PublicSubscriberView;
		
		override public function onRegister():void
		{
			view.leaveButton.addEventListener(MouseEvent.CLICK, leaveHandler);
			super.onRegister();
		}
		
		override protected function updateCasterCamera(event:PropertyChangeEvent=null):void
		{
			//return;
			if(roomModel.getRoom().casterCameraStreamID)
			{
				getView().videoDisplayInput.playStream(scopeModel.connection, roomModel.getRoom().casterCameraStreamID);
			}
			else
			{
				if (getView().videoDisplayInput.isPlaing()) getView().videoDisplayInput.stop();
			}
		}
		
		override public function onRemove():void
		{
			view.leaveButton.removeEventListener(MouseEvent.CLICK, leaveHandler);
			super.onRemove();
		}
		
		override protected function getView():StreamView
		{
			return view as StreamView;
		}
		
		private function leaveHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.LEAVE_ROOM));
		}
	
	}
}