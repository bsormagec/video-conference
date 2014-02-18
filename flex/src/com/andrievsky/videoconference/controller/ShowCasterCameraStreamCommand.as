package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.model.StreamModel;
	
	import org.robotlegs.mvcs.Command;

	public class ShowCasterCameraStreamCommand extends Command
	{
		[Inject]
		public var streamModel:StreamModel;
		
		override public function execute():void
		{
			streamModel.showStream(streamModel.casterCameraStream);
		}
	}
}