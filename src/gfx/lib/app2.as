package gfx.lib 
{
	
    include "imports.as";
	 
	public class app2 extends Sprite
	{
		
		public function app2() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		
	}
	

}