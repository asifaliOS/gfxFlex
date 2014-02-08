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
	public class game2 extends engine 
	{
		
		[Embed (source = "game1.png")] private var texture:Class;
		[Embed (source = "game1.txt",mimeType="application/octet-stream")] private var shapes:Class;
		
		private var SM:shapes_manager;
		
		public function game2() 
		{
			
			
			
		}
		private var objects:Vector.<_3dobjectfast>=new Vector.<_3dobjectfast>();
		override public function ready():void 
		{
			

			
			
			
			prepare(stage.stageWidth, stage.stageHeight);
			
			SM= new shapes_manager(__ctx);
			SM.load_3d_shapes(new texture(), new shapes() );
			SM.ready_render();
			trace(SM.templates.length);

			
			//add_object(0, -30, 0, 120);
			add_object(1, 140, 0, 130);
			add_object(2, 10, 50, 160);
			//add_object(3, 140, -60, 130);
			
			
			//add_object(4, 0, 0, 130);

		}
	 	protected function add_object(t:uint, x:Number, y:Number, z:Number):void {
			var ob:_3dobjectfast  = new _3dobjectfast();
			
			ob.position(x, y, z);
			ob.tag = t;
			ob.process();
			objects.push(ob);
			
		}
		private var ry:int = 0;
		private var rx:int = 0;
		private var ss:Number = 0;
		override public function render():void 
		{
									
			__ctx.clear(0.14, 0.4, 0.4, 1);
			
			var mv:Matrix3D = new Matrix3D();			
			mv.identity();
			
			
				
			if (keys[Keyboard.LEFT]) camera.yaw += 10;			
			if (keys[Keyboard.RIGHT]) camera.yaw -= 10;			
			if (keys[Keyboard.S]) camera.roll += 10;			
			if (keys[Keyboard.W]) camera.roll -= 10;
			
			if (keys[Keyboard.Q]) ss = 0.01;
			if (keys[Keyboard.A]) ss = -0.01;
			
			
			
			
			
			
			if (keys[Keyboard.UP]) camera.front_back(1);
			if (keys[Keyboard.DOWN]) camera.front_back(-1);
			
			camera.rotate(camera.yaw, camera.pitch, camera.roll);
			
			camera.process();
			for each(var ob:_3dobjectfast in objects) {
			//fps.text = ob.sx + "," + ob.sy;
		
						
				ob.sx += ss; 
				ob.sy += ss;
				ob.sz += ss;
				ob.rx += 20;ob.ry += 60; 
				ob.process();
				mv.rawData=ob.mat;
				//mv.appendTranslation(0, 0, 40);
				mv.append(camera.view);
				mv.append(camera.projection);				
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
				SM.draw_template(ob.tag, mv);
			
				
				}
				ss = 0;
			//	if (ry > 359) ry = 0; else ry = ry + 1;
			//if (rx > 359) rx = 0; else rx=rx+2;
				
		}
		
	}

}