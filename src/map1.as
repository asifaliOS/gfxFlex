package  
{
	import flash.sampler._getInvocationCount;
	import gfx.lib._3dobject;
	import gfx.lib._3dobjectfast;
	import gfx.lib.camera3d;
	import gfx.lib.cam3d;
	import gfx.lib.engine;
	import gfx.lib.math;
	import gfx.lib.shapes_manager;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	public class map1 extends engine 
	{
		
	
		private var SM:shapes_manager;
		
		public function map1() 
		{
			
			
			
		}
		private var objects:Vector.<_3dobjectfast>=new Vector.<_3dobjectfast>();
		override public function ready():void 
		{
						
			prepare(stage.stageWidth, stage.stageHeight);
			
			
		}
	 	
		override public function render():void 
		{
									
			__ctx.clear(0, 0, 0, 1);
			
				
				
			if (keys[Keyboard.LEFT]) camera.yaw += 10;			
			if (keys[Keyboard.RIGHT]) camera.yaw -= 10;			
			if (keys[Keyboard.S]) camera.roll += 10;			
			if (keys[Keyboard.W]) camera.roll -= 10;
			
				
			
			
			
			if (keys[Keyboard.UP]) camera.front_back(1);
			if (keys[Keyboard.DOWN]) camera.front_back(-1);
			
			camera.rotate(camera.yaw, camera.pitch, camera.roll);
			
			camera.process();
		
				
		}
		
	}

}