package com.andrievsky.videoconference.view.privatesubscriber
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.view.common.StreamMediator;
	import com.andrievsky.videoconference.view.common.StreamView;
	import com.andrievsky.videoconference.view.common.streamdisplay.StreamDisplay;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	public class PrivateSubscriberMediator extends StreamMediator
	{
		[Inject]
		public var view:PrivateSubscriberView;
		
		private var subscriberCameraWatcher:ChangeWatcher;
		
		override public function onRegister():void
		{
			view.leaveButton.addEventListener(MouseEvent.CLICK, stopHandler);
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.CREATE_SUBSCRIBER_CAMERA_STREAM));
			subscriberCameraWatcher = ChangeWatcher.watch(roomModel.getRoom(), "subscriberCameraStreamID", updateSubscriberCamera, false, true);
			super.onRegister();
		}
		
		override protected function updateCasterCamera(event:PropertyChangeEvent=null):void
		{
			if(roomModel.getRoom().casterCameraStreamID)
			{
				view.videoDisplayInput.playStream(scopeModel.connection, roomModel.getRoom().casterCameraStreamID);
			}
			else
			{
				if (view.videoDisplayInput.isPlaing()) view.videoDisplayInput.stop();
			}
		}
		
		private function updateSubscriberCamera(event:PropertyChangeEvent=null):void
		{
			if(roomModel.getRoom().subscriberCameraStreamID)
			{
				view.videoDisplayOutput.playCamera();
			}
			else
			{
				view.videoDisplayOutput.stop();
			}
		}
		
		override public function onRemove():void
		{
			subscriberCameraWatcher.unwatch();
			view.leaveButton.removeEventListener(MouseEvent.CLICK, stopHandler);
			super.onRemove();
		}
		
		
		override protected function getView():StreamView
		{
			return view as StreamView;
		}
		
		private function stopHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.LEAVE_ROOM));
		}
	}
}