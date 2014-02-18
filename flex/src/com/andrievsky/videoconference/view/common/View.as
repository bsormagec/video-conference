package com.andrievsky.videoconference.view.common
{
	import mx.core.IVisualElementContainer;
	
	import spark.components.SkinnableContainer;
	
	public class View extends SkinnableContainer
	{
		public function View()
		{
			super();
		}
		
		public function close():void
		{
			(this.parent as IVisualElementContainer).removeElement(this);
		}
	}
}