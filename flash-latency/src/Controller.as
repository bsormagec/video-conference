package
{
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.messaging.AbstractConsumer;
	
	public class Controller extends Application
	{
		Security.LOCAL_TRUSTED;
		
		private var nc:NetConnection = null;
		private var camera:Camera;
		private var microphone:Microphone;
		private var nsPublish:NetStream = null;                      
		private var nsPlay:NetStream = null;
		private var videoCamera:Video;
		private var videoRemote:Video;
		private var isEnabled:Boolean;
		public var videoRemoteContainer:UIComponent;
		public var videoCameraContainer:UIComponent;
		public var doPublish:Button;
		public var doSubscribe:Button;
		public var connectButton:Button;
		public var fpsText:Text;
		public var bufferLenText:Text;
		public var connectStr:TextInput;
		public var publishName:TextInput;
		public var subscribeName:TextInput;
		public var playerVersion:Text;
		public var prompt:Text;
		
		public function Controller()
		{
			addEventListener(FlexEvent.APPLICATION_COMPLETE,mainInit); 	
		}
		
		private function mainInit(event:FlexEvent):void
		{
			playerVersion.text = Capabilities.version+" (Flex)";
			stage.align = "TL";
			stage.scaleMode = "noScale";
			videoCamera = new Video(240, 180);
			videoCameraContainer.addChild(videoCamera);
			videoRemote = new Video(240, 180);
			videoRemoteContainer.addChild(videoRemote);
			
			connectStr.text = "rtmp://79.143.186.167/skillstr";
			connectButton.addEventListener(MouseEvent.CLICK, doConnect);
			doPublish.addEventListener(MouseEvent.CLICK, publish);
			doSubscribe.addEventListener(MouseEvent.CLICK, subscribe);
			
			enablePlayControls(false);
			
			startCamera();
		}
		
		private function startCamera():void
		{	
			// get the default Flash camera and microphone
			camera = Camera.getCamera();
			microphone = Microphone.getEnhancedMicrophone();;//Microphone.getMicrophone();
			
			// here are all the quality and performance settings that we suggest
			camera.setMode(320, 240, 15, false);
			camera.setQuality(0, 0);
			camera.setKeyFrameInterval(15);
	
			/*
			*/
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
			trace("useEchoSuppression: "+microphone.useEchoSuppression);
			//microphone.gain = 50;
			
			/*
			
			microphone.rate = 11;
			microphone.setSilenceLevel(0);
			microphone.codec = SoundCodec.SPEEX;
			microphone.encodeQuality = 5;
			microphone.framesPerPacket = 2;
			*/
			subscribeName.text = "user-stream-1";
			publishName.text = "user-stream-1";
			
		}
		
		private function ncOnStatus(infoObject:NetStatusEvent):void
		{
			trace("nc: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetConnection.Connect.Failed")
				prompt.text = "Connection failed: Try rtmp://[server-ip-address]/videochat";
			else if (infoObject.info.code == "NetConnection.Connect.Rejected")
				prompt.text = infoObject.info.description;
		}
		
		private function doConnect(event:MouseEvent):void
		{
			// connect to the Wowza Media Server
			if (nc == null)
			{
				// create a connection to the wowza media server
				nc = new NetConnection();
				nc.connect(connectStr.text);
				
				// get status information from the NetConnection object
				nc.addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);
				
				connectButton.label = "Stop";
				
				// uncomment this to monitor frame rate and buffer length
				//setInterval(updateStreamValues, 500);
				
				videoCamera.clear();
				videoCamera.attachCamera(camera);
				
				enablePlayControls(true);
			}
			else
			{
				nsPublish = null;
				nsPlay = null;
				
				videoCamera.attachCamera(null);
				videoCamera.clear();
				
				videoRemote.attachNetStream(null);
				videoRemote.clear();
				
				nc.close();
				nc = null;
				
				enablePlayControls(false);
				
				doSubscribe.label = 'Play';
				doPublish.label = 'Publish';
				
				connectButton.label = "Connect";
				prompt.text = "";
			}
		}
		
		private function enablePlayControls(isEnable:Boolean):void
		{
			doPublish.enabled = isEnable;
			doSubscribe.enabled = isEnable;
			publishName.enabled = isEnable;
			subscribeName.enabled = isEnable;
		}
		
		// function to monitor the frame rate and buffer length
		private function updateStreamValues():void
		{
			if (nsPlay != null)
			{
				fpsText.text = (Math.round(nsPlay.currentFPS*1000)/1000)+" fps";
				bufferLenText.text = (Math.round(nsPlay.bufferLength*1000)/1000)+" secs";
			}
			else
			{
				fpsText.text = "";
				bufferLenText.text = "";
			}
		}
		
		private function nsPlayOnStatus(infoObject:NetStatusEvent):void
		{
			trace("nsPlay: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed")
				prompt.text = infoObject.info.description;
		}
		
		private function subscribe(event:MouseEvent):void
		{
			if (doSubscribe.label == 'Play')
			{
				// create a new NetStream object for video playback
				nsPlay = new NetStream(nc);
				
				// trace the NetStream status information
				nsPlay.addEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
				
				var nsPlayClientObj:Object = new Object();
				nsPlay.client = nsPlayClientObj;
				nsPlayClientObj.onMetaData = function(infoObject:Object):void
				{
					trace("onMetaData");
					
					// print debug information about the metaData
					for (var propName:String in infoObject)
					{
						trace("  "+propName + " = " + infoObject[propName]);
					}
				};		
				
				// set the buffer time to zero since it is chat
				nsPlay.bufferTime = 0;
				
				// subscribe to the named stream
				nsPlay.play(subscribeName.text);
				
				// attach to the stream
				videoRemote.attachNetStream(nsPlay);
				
				doSubscribe.label = 'Stop';
			}
			else
			{		
				// here we are shutting down the connection to the server
				videoRemote.attachNetStream(null);
				nsPlay.play(null);
				nsPlay.close();
				
				doSubscribe.label = 'Play';
			}
		}
		
		private function nsPublishOnStatus(infoObject:NetStatusEvent):void
		{
			trace("nsPublish: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed")
				prompt.text = infoObject.info.description;
		}
		
		private function publish(event:MouseEvent):void
		{
			if (doPublish.label == 'Publish')
			{
				// create a new NetStream object for video publishing
				nsPublish = new NetStream(nc);
				
				var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
				//H264VideoStreamSettings = new H264VideoStreamSettings();
				h264Settings.setProfileLevel(H264Profile.BASELINE,H264Level.LEVEL_3);
				nsPublish.videoStreamSettings = h264Settings;
				
				nsPublish.addEventListener(NetStatusEvent.NET_STATUS, nsPublishOnStatus);
				
				// set the buffer time to zero since it is chat
				nsPublish.bufferTime = 0;
				
				// publish the stream by name
				nsPublish.publish(publishName.text);
				
				// add custom metadata to the stream
				var metaData:Object = new Object();
				metaData["description"] = "Chat using VideoChat example."
				nsPublish.send("@setDataFrame", "onMetaData", metaData);
				
				// attach the camera and microphone to the server
				nsPublish.attachCamera(camera);
				nsPublish.attachAudio(microphone);
				
				doPublish.label = 'Stop';
			}
			else
			{
				// here we are shutting down the connection to the server
				nsPublish.attachCamera(null);
				nsPublish.attachAudio(null);
				nsPublish.publish("null");
				nsPublish.close();
				
				doPublish.label = 'Publish';
			}
		}
		
	}
}