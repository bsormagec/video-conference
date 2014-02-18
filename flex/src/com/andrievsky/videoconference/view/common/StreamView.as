package com.andrievsky.videoconference.view.common
{
	import com.andrievsky.videoconference.model.vo.RoomVO;
	import com.andrievsky.videoconference.view.common.chat.ChatView;
	import com.andrievsky.videoconference.view.common.streamdisplay.StreamDisplay;
	import com.andrievsky.videoconference.view.controls.ControlsView;
	
	import mx.core.UIComponent;
	
	import spark.components.List;

	public class StreamView extends View
	{
		
		// Define public variables children components.    
		public var usersList:List;
		public var videoDisplayOutput:StreamDisplay;
		public var videoDisplayInput:StreamDisplay;
		[Bindable]
		public var room:RoomVO;
		//public var chat:ChatView;
		public var controls:ControlsView;

		public function StreamView()
		{
			super();
		}
	}
}