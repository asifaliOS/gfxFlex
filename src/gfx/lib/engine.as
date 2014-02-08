package gfx.lib 
{
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.utils.*;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.system.System;
	
	public class engine extends Sprite
	{
		
		// Context 3D instance
		public var __ctx:Context3D;
		public var shaders_compiler:agal = new agal();
		public var lights:Array = [];
		public var default_shaders:Program3D;
		public var keys:Vector.<Boolean> = new Vector.<Boolean>(255);
		public var projection:pmatrix3d = new pmatrix3d();
		public var fps_timer:int, fps_last_timer:int, fps_counter:int, frame_rate:int, df_last_timer:int;
		public var fps:TextField = new TextField();

		public var camera:camera3d = new camera3d();
		
		public function engine() 
		{
			
			math.INIT();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, on_context_init);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
			
			
			
		}
		
		public function ready():void
		{
			
		}
		
		public function render():void
		{
			
		}
		
		public function prepare(_width:Number,_height:Number):void
		{
			__ctx.configureBackBuffer( _width, _height, 2, true);	
				
			default_shaders = __ctx.createProgram();
			
			
						
			/*
			default_shaders.upload(
			shaders_compiler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\nmov v0, va1"),
			shaders_compiler.assemble(Context3DProgramType.FRAGMENT, "mov oc, v0")
			);
			
			
			__ctx.setProgram(default_shaders);
			*/
			
			
			//__ctx.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
			//__ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 0]));
			}
		
		
			
		private function on_render_internal(event:Event):void {
			// Clear up the context
			//__ctx.clear(0, 0, 0, 0);
			
			fps_timer = getTimer();
			
			if (Math.abs(fps_timer - df_last_timer) > 20) {				
				
				df_last_timer = fps_timer ;
				if(Math.abs(fps_timer - fps_last_timer)>1000)
				{
					fps_last_timer = fps_timer ;
					frame_rate = fps_counter ;
					fps_counter = 0;
					
					fps.text = frame_rate + " fps |"+ Math.round(((System.totalMemory/1024)/1024)) +"|"+System.processCPUUsage.toString();
					
				}	
				else fps_counter++;
				
				
				render();
				// Present it
				
				
				__ctx.present();
			}
			
			
			
		}
		
		private function on_context_init(event:Event):void {
			
			var stage3D:Stage3D = event.target as Stage3D;
			__ctx = stage3D.context3D;
			
			camera.set(0, 0, -60, 0, 0,  0, 0.1, 512,  45*math.DEG_TO_RAD_HELP,stage.stageWidth,stage.stageHeight);
			
			
			ready();
			addEventListener(Event.ENTER_FRAME, on_render_internal)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
    
			// Setup UI
			//fps.background = true;
			//fps.backgroundColor = 0xffffffff;
			//fps.autoSize= TextFieldAutoSize.LEFT;
			fps.textColor = 0xffffffff;
			fps.text = "Getting FPS...";
			addChild(fps);


		}
		public function key_handler(event:KeyboardEvent, isDown:Boolean):Boolean
		{
			return(true);
		}
		private function keyPressed(event:KeyboardEvent):void
		{
			keys[event.keyCode] =key_handler(event, true);
			 
		}
		private function keyReleased(event:KeyboardEvent):void
		{
			key_handler(event, false);
			keys[event.keyCode] = false;
		}

		
	
	
	}

}
