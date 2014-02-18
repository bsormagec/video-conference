package com.andrievsky.videoconference.view.common
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.ConfigModel;
	import com.andrievsky.videoconference.model.FullScreenModel;
	import com.andrievsky.videoconference.model.RoomModel;
	import com.andrievsky.videoconference.model.ScopeModel;
	import com.andrievsky.videoconference.view.common.streamdisplay.StreamDisplay;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	import org.osmf.net.StreamType;
	import org.robotlegs.mvcs.Mediator;
	
	public class StreamMediator extends Mediator
	{
		[Inject]
		public var roomModel:RoomModel;
		[Inject]
		public var congidModel:ConfigModel;
		[Inject]
		public var scopeModel:ScopeModel;
		[Inject]
		public var fullScreenModel:FullScreenModel;
		
		private var casterCameraWatcher:ChangeWatcher;
		
		override public function onRegister():void
		{
			casterCameraWatcher = ChangeWatcher.watch(roomModel.getRoom(), "casterCameraStreamID", updateCasterCamera, false, true);
			getView().room = roomModel.getRoom();
			if (roomModel.getRoom().casterCameraStreamID) updateCasterCamera();
			if (getView().videoDisplayInput) getView().videoDisplayInput.addEventListener(StreamDisplay.FULL_SCREEN, fullScreenHandler);
			if (getView().videoDisplayOutput)
			{
				getView().videoDisplayOutput.addEventListener(StreamDisplay.MIC_MUTE, muteHandler);
				getView().videoDisplayOutput.addEventListener(StreamDisplay.MIC_UNMUTE, unmuteHandler);
				getView().videoDisplayOutput.addEventListener(StreamDisplay.CAPTURE_SHOW, cameraMuteHandler);
				getView().videoDisplayOutput.addEventListener(StreamDisplay.CAPTURE_HIDE, caneraUnmuteHandler);
			}
		}
		
		protected function fullScreenHandler(event:Event):void
		{
			fullScreenModel.switchToFullScreen(getView().videoDisplayInput.videoContainer, getView().controls);
		}
		
		protected function muteHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.MUTE_CASTER_CAMERA_STREAM));
		}
		
		protected function unmuteHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.UNMUTE_CASTER_CAMERA_STREAM));
		}
		
		protected function cameraMuteHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.HIDE_CASTER_CAMERA_STREAM));
		}
		
		protected function caneraUnmuteHandler(event:Event):void
		{
			dispatch(new RTMPServiceEvent(RTMPServiceEvent.SHOW_CASTER_CAMERA_STREAM));
		}
		
		protected function getView():StreamView
		{
			// Has to be overriden with view property
			return null;
		}
		
		override public function onRemove():void
		{
			casterCameraWatcher.unwatch();
		}
		
		protected function updateCasterCamera(event:PropertyChangeEvent=null):void
		{
			//return;
			if(roomModel.getRoom().casterCameraStreamID)
			{
				getView().videoDisplayOutput.playStream(scopeModel.connection, roomModel.getRoom().casterCameraStreamID);
			}
			else
			{
				if (getView().videoDisplayOutput.isPlaing()) getView().videoDisplayOutput.stop();
			}
		}
	}
}