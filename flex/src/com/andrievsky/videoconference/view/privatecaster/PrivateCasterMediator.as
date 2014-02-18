package com.andrievsky.videoconference.view.privatecaster
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.view.common.StreamMediator;
	import com.andrievsky.videoconference.view.common.StreamView;
	import com.andrievsky.videoconference.view.common.streamdisplay.StreamDisplay;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	public class PrivateCasterMediator extends StreamMediator
	{
		[Inject]
		public var view:PrivateCasterView;
		
		private var subscriberCameraWatcher:ChangeWatcher;
		
		override public function onRegister():void
		{
			view.stopButton.addEventListener(MouseEvent.CLICK, stopHandler);
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.CREATE_CASTER_CAMERA_STREAM));
			subscriberCameraWatcher = ChangeWatcher.watch(roomModel.getRoom(), "subscriberCameraStreamID", updateSubscriberCamera, false, true);
			super.onRegister();
		}
		
		
		override protected function updateCasterCamera(event:PropertyChangeEvent=null):void
		{
			if(roomModel.getRoom().casterCameraStreamID)
			{
				view.videoDisplayOutput.playCamera();
			}
			else
			{
				view.videoDisplayOutput.stop();
			}
		}
		
		private function updateSubscriberCamera(event:PropertyChangeEvent=null):void
		{
			if(roomModel.getRoom().subscriberCameraStreamID)
			{
				view.videoDisplayInput.playStream(scopeModel.connection, roomModel.getRoom().subscriberCameraStreamID);
			}
			else
			{
				view.videoDisplayInput.stop();
			}
		}
		
		override public function onRemove():void
		{
			subscriberCameraWatcher.unwatch();
			view.stopButton.removeEventListener(MouseEvent.CLICK, stopHandler);
			super.onRemove();
		}
		
		
		override protected function getView():StreamView
		{
			return view as StreamView;
		}
		
		private function stopHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.CLOSE_ROOM));
		}
	}
}