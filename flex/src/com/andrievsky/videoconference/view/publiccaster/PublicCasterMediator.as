package com.andrievsky.videoconference.view.publiccaster
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ConfigModel;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.view.common.StreamMediator;
	import com.andrievsky.videoconference.view.common.StreamView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;

	public class PublicCasterMediator extends StreamMediator
	{
		[Inject]
		public var view:PublicCasterView;
		
		override public function onRegister():void
		{
			view.stopButton.addEventListener(MouseEvent.CLICK, stopHandler);
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.CREATE_CASTER_CAMERA_STREAM));
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			view.stopButton.removeEventListener(MouseEvent.CLICK, stopHandler);
			super.onRemove();
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