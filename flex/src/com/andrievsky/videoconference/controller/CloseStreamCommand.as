package com.andrievsky.videoconference.controller
{
	import com.andrievsky.videoconference.event.RTMPServiceEvent;
	import com.andrievsky.videoconference.model.StreamModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class CloseStreamCommand extends Command
	{
		[Inject]
		public var event:RTMPServiceEvent;
		
		
		override public function execute():void
		{
			
		}
	}
}