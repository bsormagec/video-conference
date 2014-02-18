package com.andrievsky.skillstr.model
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.service.rtmp.RTMPService;
	
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.utils.UIDUtil;
	
	import org.osmf.net.StreamType;
	import org.robotlegs.mvcs.Actor;
	
	public class StreamModel extends Actor
	{	
		[Inject]
		public var scopeModel:ScopeModel;
		
		public var casterCameraStreamID:String;
		public var casterCameraStream:NetStream = null;
		public var subscriberCameraStreamID:String;
		public var subscriberCameraStream:NetStream = null;
		private var detectedCameraWidth:int;
		private var detectedCameraHeight:int;
		
		private var camera:Camera;
		private var microphone:Microphone;
		
		public function publishCasterCameraStream():void
		{
			casterCameraStreamID = UIDUtil.createUID();
			casterCameraStream = publishStream(scopeModel.connection, casterCameraStreamID, casterCameraStreamStatusHandler);
		}
		
		private function publishStream(connection:NetConnection, streamID:String, statusHandler:Function):NetStream
		{
			// create netstream
			var stream:NetStream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			// setup camera and mic
			camera = Camera.getCamera();
			microphone = Microphone.getEnhancedMicrophone();
			
			// here are all the quality and performance settings that we suggest
			if (detectedCameraWidth == 0 || detectedCameraHeight == 0)
			{
				detectCameraResolution();
			}
			camera.setMode(detectedCameraWidth, detectedCameraHeight, 15, true);
			camera.setQuality(0, 95);
			camera.setKeyFrameInterval(15);
			
			microphone.codec = SoundCodec.SPEEX;
			microphone.encodeQuality = 6;
			microphone.framesPerPacket = 2;
			
			//  Code for Using AEC 
			// http://videostreamingexpert.blog.com/2011/06/12/flash-player-10-3-acoustic-echo-cancellation/
			var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			options.autoGain = false;
			options.echoPath = 128;
			options.nonLinearProcessing = true;
			microphone.enhancedOptions = options;
			microphone.setUseEchoSuppression(true);
			
			microphone.setSilenceLevel(0, 2000);
			
			
			
			// set the buffer time to zero since it is chat
			stream.bufferTime = 0;
			// publish the stream by name
			stream.publish(streamID, StreamType.LIVE);
			// attach the camera and microphone to the server
			stream.attachCamera(camera);
			stream.attachAudio(microphone);
			return stream;
		}
		
		public function publishSubscriberCameraStream():void
		{
			subscriberCameraStreamID = UIDUtil.createUID();
			subscriberCameraStream = publishStream(scopeModel.connection, subscriberCameraStreamID, subscriberCameraStreamStatusHandler);
		}
		
		public function closeStream(streamID:String):void
		{
			switch(streamID)
			{
				case casterCameraStreamID:
				{
					casterCameraStreamID = null;
					closeNetStream(casterCameraStream);
					break;
				}
					
				case subscriberCameraStreamID:
				{
					subscriberCameraStreamID = null;
					closeNetStream(subscriberCameraStream);
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public function closeAllStreams():void
		{
			if (casterCameraStream) closeNetStream(casterCameraStream);
			if (subscriberCameraStream) closeNetStream(casterCameraStream);
		}
		
		private function closeNetStream(netStream:NetStream):void
		{
			if (!netStream) return;
			netStream.attachCamera(null);
			netStream.attachAudio(null);
			netStream.play(null);
			netStream.close();
		}
		
		public function muteStream(stream:NetStream):void
		{
			if (!stream) return;
			stream.attachAudio(null);
		}
		
		public function unmuteStream(stream:NetStream):void
		{
			if (!stream) return;
			stream.attachAudio(microphone);
		}
		
		public function showStream(stream:NetStream):void
		{
			if (!stream) return;
			stream.attachCamera(camera);
		}
		
		public function hideStream(stream:NetStream):void
		{
			if (!stream) return;
			stream.attachCamera(null);
		}
		
		private function casterCameraStreamStatusHandler(infoObject:NetStatusEvent):void
		{
			if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed")
			{
				scopeModel.logger.error("casterCameraStreamStatus: "+infoObject.info.description);
			}
			else if(infoObject.info.code == "NetStream.Publish.Start")
			{
				scopeModel.logger.info(infoObject.info.code+" "+infoObject.info.description);
				dispatch(new RTMPServiceEvent(RTMPServiceEvent.ADD_CASTER_CAMERA_STREAM));
			}
			else
			{
				scopeModel.logger.info(infoObject.info.code+" "+infoObject.info.description);
			}
		}
		
		private function subscriberCameraStreamStatusHandler(infoObject:NetStatusEvent):void
		{
			if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed")
			{
				scopeModel.logger.error("casterCameraStreamStatus: "+infoObject.info.description);
			}
			else if(infoObject.info.code == "NetStream.Publish.Start")
			{
				scopeModel.logger.info(infoObject.info.code+" "+infoObject.info.description);
				dispatch(new RTMPServiceEvent(RTMPServiceEvent.ADD_SUBSCRIBER_CAMERA_STREAM));
			}
			else
			{
				scopeModel.logger.info(infoObject.info.code+" "+infoObject.info.description);
			}
		}
		
		private function detectCameraResolution():void
		{
			camera.setMode(64000, 48000, 15, false);
			var width:int = camera.width;
			var height:int = camera.height;
			if (width > 1280) width = 1280;
			if (height > 720) height = 720;
			/*if (width > 1920) width = 1920;
			if (height > 1080) height = 1080;*/
			detectedCameraWidth = width;
			detectedCameraHeight = height;
		}
	}
}