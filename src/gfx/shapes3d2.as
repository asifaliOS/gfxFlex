package gfx 
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import gfx.lib.engine;
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;

	public class shapes3d2 extends engine
	{
		
		[Embed (source = "../../t1.png")] private var sheet_texture_class:Class;
		private var sheet_texture_bmp:Bitmap = new sheet_texture_class();
		// The Molehill Texture that uses the above myTextureData
		private var sheet_texture:Texture;
		public function prep_texture():void {
				
			// Generate mipmaps
			var ws:int = sheet_texture_bmp.bitmapData.width;
			var hs:int = sheet_texture_bmp.bitmapData.height;
			sheet_texture =__ctx.createTexture(ws, hs,Context3DTextureFormat.BGRA, false);
			
			var level:int = 0; var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			while ( ws >= 1 && hs >= 1 ) {
			tmp.draw(sheet_texture_bmp.bitmapData, transform, null, null,
			null, true);
			sheet_texture.uploadFromBitmapData(tmp, level);
			transform.scale(0.5, 0.5); level++; ws >>= 1; hs >>= 1;
			if (hs && ws) {
			tmp.dispose();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			}
			}
			tmp.dispose();
		}
	
		override public function ready():void 
		{
			
			prepare(stage.stageWidth, stage.stageHeight);
			//__ctx.setCulling( Context3DTriangleFace.NONE);
			__ctx.enableErrorChecking = true;
			load_shapes();
			
	
			
	
			default_shaders.upload(
			shaders_compiler.assemble(Context3DProgramType.VERTEX, "m44 op,va0,vc4\nm33 v0.xyz,va2.xyz,vc4\nmov v0.w,vc8.x\nmov v1,va1"),
			shaders_compiler.assemble(Context3DProgramType.FRAGMENT,"tex ft0,v1.xy,fs0 <2d,linear,wrap,miplinear>\nnrm ft1.xyz,v0.xyz\ndp3 ft1.w,ft1.xyz,fc2.xyz\nmax ft1.x,ft1.w,fc2.w\nmul ft2,ft0,ft1.x\nmul ft2,ft2,fc0\nmul ft1,ft0,fc1\nadd ft2,ft2,ft1\nsat oc,ft2")
			);
						
			
		
			 __ctx.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, Vector.<Number>([1,1,1,1]));
			
			  
			
			
			 
			 __ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 0]));
			 __ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.1,0.1,0.1,1]));
			 __ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([0.0,0.4,-0.8,0]));
			 __ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([0,0,0,0]));
			
			
			
			
			
			
			__ctx.setVertexBufferAt( 0, vbf, 0, Context3DVertexBufferFormat.FLOAT_4);
			__ctx.setVertexBufferAt( 1, vbf, 4, Context3DVertexBufferFormat.FLOAT_2 ); 
			__ctx.setVertexBufferAt( 2, vbf, 8, Context3DVertexBufferFormat.FLOAT_4); 
			
			
			__ctx.setProgram(default_shaders);
			
			
			
			__ctx.setTextureAt(0, sheet_texture);
			projection.perspectiveFieldOfViewLH(45*Math.PI/180, 1.2, 0.1, 512);
			
			
			
		}
		private var ry:Number = 0;
		override public function render():void 
		{
			__ctx.clear(0.4, 0.4, 0.4, 1);
			
			
			var mt:Matrix3D = new Matrix3D();		
			var mv:Matrix3D = new Matrix3D();			
			mt.identity();
			mv.identity();
			
			mv.appendRotation( ry, Vector3D.Y_AXIS);
			mv.appendRotation( ry, Vector3D.X_AXIS);
	
			if (ry > 359) ry = 0; else ry=ry+0.7;
			
			mv.appendTranslation( 0, 0, 70);
			mt.append(mv);
			
			mt.append( projection);
			__ctx.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 4, mt, true );
			
			//projection.append(mt);
			__ctx.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
			
			

			
			for each(var ss:__shape3d in __shapes) {
					__ctx.drawTriangles( idx, ss.istart, ss.icount);
					
			}
			
			
			//__ctx.drawTriangles( idx, 0, this.total_traingles );
		}
		//=================================================
		private var __shapes:Vector.<__shape3d>=new Vector.<__shape3d>();
		private var total_traingles:uint = 0;
			
		private function load_shapes():void {
		
			
			var data:String = ( <![CDATA[
			[ 			
		
		{"n":"name","v":[0,15,0,0,1,0,0,0,0,15,0,0,1,0,0.25,0,0,15,0,0,1,0,0.5,0,0,15,0,0,1,0,0.75,0,0,15,0,0,1,0,1,0,25,15,0,0.698,0.7115,-0.0816,0,0.303,0,15,25,0.2357,0.6667,0.7071,0.25,0.303,-25,15,0,-0.7071,0.6667,0.2357,0.5,0.303,0,15,-25,-0.2357,0.6667,-0.7071,0.75,0.303,25,15,0,0.698,0.7115,-0.0816,1,0.303,25,-17.5,0,0.698,-0.7115,0.0816,0,0.697,0,-17.5,25,-0.2357,-0.6667,0.7071,0.25,0.697,-25,-17.5,0,-0.7071,-0.6667,-0.2357,0.5,0.697,0,-17.5,-25,0.2357,-0.6667,-0.7071,0.75,0.697,25,-17.5,0,0.698,-0.7115,0.0816,1,0.697,0,-17.5,0,0,-1,0,0,1,0,-17.5,0,0,-1,0,0.25,1,0,-17.5,0,0,-1,0,0.5,1,0,-17.5,0,0,-1,0,0.75,1,0,-17.5,0,0,-1,0,1,1],"f":[0,5,1,1,5,6,1,6,2,2,6,7,2,7,3,3,7,8,3,8,4,4,8,9,5,10,6,6,10,11,6,11,7,7,11,12,7,12,8,8,12,13,8,13,9,9,13,14,10,15,11,11,15,16,11,16,12,12,16,17,12,17,13,13,17,18,13,18,14,14,18,19]},
			
			{"n":"name","v":[0,7.5,0,0,1,0,0,0.04,0,7.5,0,0,1,0,0.2,0.04,0,7.5,0,0,1,0,0.4,0.04,0,7.5,0,0,1,0,0.6,0.04,0,7.5,0,0,1,0,0.8,0.04,0,7.5,0,0,1,0,1,0.04,0,7.5,0,0,1,0,1.2,0.04,15,7.5,0,0.7676,0.6388,-0.0518,0,0.2,7.5,7.5,12.99,0.5222,0.603,0.603,0.2,0.2,-7.5,7.5,12.99,-0.2611,0.603,0.7538,0.4,0.2,-15,7.5,0,-0.7833,0.603,0.1508,0.6,0.2,-7.5,7.5,-12.99,-0.5222,0.603,-0.603,0.8,0.2,7.5,7.5,-12.99,0.2611,0.603,-0.7538,1,0.2,15,7.5,0,0.7676,0.6388,-0.0518,1.2,0.2,15,-22.5,0,0.0078,-0.2295,0.9733,0,0.36,7.5,-22.5,12.99,-0.839,-0.2295,0.4934,0.2,0.36,-7.5,-22.5,12.99,-0.8468,-0.2295,-0.4799,0.4,0.36,-15,-22.5,0,-0.0078,-0.2295,-0.9733,0.6,0.36,-7.5,-22.5,-12.99,0.839,-0.2295,-0.4934,0.8,0.36,7.5,-22.5,-12.99,0.8468,-0.2295,0.4799,1,0.36,15,-22.5,0,0.0078,-0.2295,0.9733,1.2,0.36,12.5,5,0,-0.7333,-0.678,-0.051,0,0.52,6.25,5,10.825,-0.2497,-0.6466,-0.7208,0.2,0.52,-6.25,5,10.825,0.4994,-0.6466,-0.5767,0.4,0.52,-12.5,5,0,0.7491,-0.6466,0.1442,0.6,0.52,-6.25,5,-10.825,0.2497,-0.6466,0.7208,0.8,0.52,6.25,5,-10.825,-0.4994,-0.6466,0.5767,1,0.52,12.5,5,0,-0.7333,-0.678,-0.051,1.2,0.52,0,5,0,0,-1,0,0,0.68,0,5,0,0,-1,0,0.2,0.68,0,5,0,0,-1,0,0.4,0.68,0,5,0,0,-1,0,0.6,0.68,0,5,0,0,-1,0,0.8,0.68,0,5,0,0,-1,0,1,0.68,0,5,0,0,-1,0,1.2,0.68,0,5,0,0,0,0,0,0.84,0,5,0,0,0,0,0.2,0.84,0,5,0,0,0,0,0.4,0.84,0,5,0,0,0,0,0.6,0.84,0,5,0,0,0,0,0.8,0.84,0,5,0,0,0,0,1,0.84,0,5,0,0,0,0,1.2,0.84],"f":[0,7,1,1,7,8,1,8,2,2,8,9,2,9,3,3,9,10,3,10,4,4,10,11,4,11,5,5,11,12,5,12,6,6,12,13,7,14,8,8,14,15,8,15,9,9,15,16,9,16,10,10,16,17,10,17,11,11,17,18,11,18,12,12,18,19,12,19,13,13,19,20,14,21,15,15,21,22,15,22,16,16,22,23,16,23,17,17,23,24,17,24,18,18,24,25,18,25,19,19,25,26,19,26,20,20,26,27,21,28,22,22,28,29,22,29,23,23,29,30,23,30,24,24,30,31,24,31,25,25,31,32,25,32,26,26,32,33,26,33,27,27,33,34,28,35,29,29,35,36,29,36,30,30,36,37,30,37,31,31,37,38,31,38,32,32,38,39,32,39,33,33,39,40,33,40,34,34,40,41]},
			{"name":"name1","v":[0,17.5,0,0.1642,0.985,-0.0533,0,0.0345,0,17.5,0,0.1642,0.985,0.0533,0.1111,0.0345,0,17.5,0,0.1015,0.985,0.1396,0.2222,0.0345,0,17.5,0,0,0.985,0.1726,0.3333,0.0345,0,17.5,0,-0.1015,0.985,0.1396,0.4444,0.0345,0,17.5,0,-0.1642,0.985,0.0533,0.5556,0.0345,0,17.5,0,-0.1642,0.985,-0.0533,0.6667,0.0345,0,17.5,0,-0.1015,0.985,-0.1396,0.7778,0.0345,0,17.5,0,0,0.985,-0.1726,0.8889,0.0345,0,17.5,0,0.1015,0.985,-0.1396,1,0.0345,0,17.5,0,0.1642,0.985,-0.0533,1.1111,0.0345,15,15,0,0.8335,0.5521,-0.0234,0,0.1724,12.135,15,8.817,0.7339,0.5247,0.4315,0.1111,0.1724,4.635,15,14.266,0.3401,0.5247,0.7804,0.2222,0.1724,-4.635,15,14.266,-0.1836,0.5247,0.8313,0.3333,0.1724,-12.135,15,8.817,-0.6371,0.5247,0.5646,0.4444,0.1724,-15,15,0,-0.8473,0.5247,0.0823,0.5556,0.1724,-12.135,15,-8.817,-0.7339,0.5247,-0.4315,0.6667,0.1724,-4.635,15,-14.266,-0.3401,0.5247,-0.7804,0.7778,0.1724,4.635,15,-14.266,0.1836,0.5247,-0.8313,0.8889,0.1724,12.135,15,-8.817,0.6371,0.5247,-0.5646,1,0.1724,15,15,0,0.8335,0.5521,-0.0234,1.1111,0.1724,15,-22.5,0,0.6872,-0.7226,0.0744,0,0.3103,12.135,-22.5,8.817,0.5122,-0.7226,0.4642,0.1111,0.3103,4.635,-22.5,14.266,0.1416,-0.7226,0.6766,0.2222,0.3103,-4.635,-22.5,14.266,-0.2832,-0.7226,0.6306,0.3333,0.3103,-12.135,-22.5,8.817,-0.5997,-0.7226,0.3437,0.4444,0.3103,-15,-22.5,0,-0.6872,-0.7226,-0.0744,0.5556,0.3103,-12.135,-22.5,-8.817,-0.5122,-0.7226,-0.4642,0.6667,0.3103,-4.635,-22.5,-14.266,-0.1416,-0.7226,-0.6766,0.7778,0.3103,4.635,-22.5,-14.266,0.2832,-0.7226,-0.6306,0.8889,0.3103,12.135,-22.5,-8.817,0.5997,-0.7226,-0.3437,1,0.3103,15,-22.5,0,0.6872,-0.7226,0.0744,1.1111,0.3103,12.5,-22.5,0,-0.6625,-0.7456,0.0718,0,0.4483,10.113,-22.5,7.347,-0.5782,-0.7456,-0.3314,0.1111,0.4483,3.863,-22.5,11.888,-0.273,-0.7456,-0.6079,0.2222,0.4483,-3.863,-22.5,11.888,0.1365,-0.7456,-0.6523,0.3333,0.4483,-10.113,-22.5,7.347,0.4938,-0.7456,-0.4475,0.4444,0.4483,-12.5,-22.5,0,0.6625,-0.7456,-0.0718,0.5556,0.4483,-10.113,-22.5,-7.347,0.5782,-0.7456,0.3314,0.6667,0.4483,-3.863,-22.5,-11.888,0.273,-0.7456,0.6079,0.7778,0.4483,3.863,-22.5,-11.888,-0.1365,-0.7456,0.6523,0.8889,0.4483,10.113,-22.5,-7.347,-0.4938,-0.7456,0.4475,1,0.4483,12.5,-22.5,0,-0.6625,-0.7456,0.0718,1.1111,0.4483,10,12.5,0,-0.7691,-0.6385,-0.03,0,0.5862,8.09,12.5,5.878,-0.5873,-0.6099,-0.5322,0.1111,0.5862,3.09,12.5,9.511,-0.1623,-0.6099,-0.7757,0.2222,0.5862,-3.09,12.5,9.511,0.3246,-0.6099,-0.723,0.3333,0.5862,-8.09,12.5,5.878,0.6876,-0.6099,-0.3941,0.4444,0.5862,-10,12.5,0,0.7879,-0.6099,0.0853,0.5556,0.5862,-8.09,12.5,-5.878,0.5873,-0.6099,0.5322,0.6667,0.5862,-3.09,12.5,-9.511,0.1623,-0.6099,0.7757,0.7778,0.5862,3.09,12.5,-9.511,-0.3246,-0.6099,0.723,0.8889,0.5862,8.09,12.5,-5.878,-0.6876,-0.6099,0.3941,1,0.5862,10,12.5,0,-0.7691,-0.6385,-0.03,1.1111,0.5862,0,12.5,0,0,-1,0,0,0.7241,0,12.5,0,0,-1,0,0.1111,0.7241,0,12.5,0,0,-1,0,0.2222,0.7241,0,12.5,0,0,-1,0,0.3333,0.7241,0,12.5,0,0,-1,0,0.4444,0.7241,0,12.5,0,0,-1,0,0.5556,0.7241,0,12.5,0,0,-1,0,0.6667,0.7241,0,12.5,0,0,-1,0,0.7778,0.7241,0,12.5,0,0,-1,0,0.8889,0.7241,0,12.5,0,0,-1,0,1,0.7241,0,12.5,0,0,-1,0,1.1111,0.7241,0,12.5,0,0,0,0,0,0.8621,0,12.5,0,0,0,0,0.1111,0.8621,0,12.5,0,0,0,0,0.2222,0.8621,0,12.5,0,0,0,0,0.3333,0.8621,0,12.5,0,0,0,0,0.4444,0.8621,0,12.5,0,0,0,0,0.5556,0.8621,0,12.5,0,0,0,0,0.6667,0.8621,0,12.5,0,0,0,0,0.7778,0.8621,0,12.5,0,0,0,0,0.8889,0.8621,0,12.5,0,0,0,0,1,0.8621,0,12.5,0,0,0,0,1.1111,0.8621],"f":[0,11,1,1,11,12,1,12,2,2,12,13,2,13,3,3,13,14,3,14,4,4,14,15,4,15,5,5,15,16,5,16,6,6,16,17,6,17,7,7,17,18,7,18,8,8,18,19,8,19,9,9,19,20,9,20,10,10,20,21,11,22,12,12,22,23,12,23,13,13,23,24,13,24,14,14,24,25,14,25,15,15,25,26,15,26,16,16,26,27,16,27,17,17,27,28,17,28,18,18,28,29,18,29,19,19,29,30,19,30,20,20,30,31,20,31,21,21,31,32,22,33,23,23,33,34,23,34,24,24,34,35,24,35,25,25,35,36,25,36,26,26,36,37,26,37,27,27,37,38,27,38,28,28,38,39,28,39,29,29,39,40,29,40,30,30,40,41,30,41,31,31,41,42,31,42,32,32,42,43,33,44,34,34,44,45,34,45,35,35,45,46,35,46,36,36,46,47,36,47,37,37,47,48,37,48,38,38,48,49,38,49,39,39,49,50,39,50,40,40,50,51,40,51,41,41,51,52,41,52,42,42,52,53,42,53,43,43,53,54,44,55,45,45,55,56,45,56,46,46,56,57,46,57,47,47,57,58,47,58,48,48,58,59,48,59,49,49,59,60,49,60,50,50,60,61,50,61,51,51,61,62,51,62,52,52,62,63,52,63,53,53,63,64,53,64,54,54,64,65,55,66,56,56,66,67,56,67,57,57,67,68,57,68,58,58,68,69,58,69,59,59,69,70,59,70,60,60,70,71,60,71,61,61,71,72,61,72,62,62,72,73,62,73,63,63,73,74,63,74,64,64,74,75,64,75,65,65,75,76]},
			{"name":"name2","v":[-12.5,12.5,-12.5,0,0.848,-0.53, 0.04, 0.059,12.5,12.5,-12.5,0.349,0.625,-0.698,0.2,0.059,12.5,12.5,12.5,0.474,0.848,0.237,0.36,0.059,-12.5,12.5,12.5,-0.349,0.625,0.698,0.52,0.059,-12.5,12.5,-12.5,-1,0,0,0.68,0.059,-12.5,12.5,-12.5,0,0.848,-0.53,0.84,0.059,-12.5,0,-12.5,0,0,-1,0.04,0.294,12.5,0,-12.5,0.707,0,-0.707,0.2,0.294,12.5,0,12.5,0.707,0,0.707,0.36,0.294,-12.5,0,12.5,-0.707,0,0.707,0.52,0.294,-12.5,0,-12.5,-1,0,0,0.68,0.294,-12.5,0,-12.5,0,0,-1,0.84,0.294,-12.5,-12.5,-12.5,0,0,-1,0.04,0.529,12.5,-12.5,-12.5,0.894,0,-0.447,0.2,0.529,12.5,-12.5,12.5,0.447,0,0.894,0.36,0.529,-12.5,-12.5,12.5,-0.894,0,0.447,0.52,0.529,-12.5,-12.5,-12.5,-1,0,0,0.68,0.529,-12.5,-12.5,-12.5,0,0,-1,0.84,0.529,-12.5,-12.5,-12.5,0,-1,0,0.04,0.765,12.5,-12.5,-12.5,0,-1,0,0.2,0.765,12.5,-12.5,12.5,0,-1,0,0.36,0.765,-12.5,-12.5,12.5,0,-1,0,0.52,0.765,-12.5,-12.5,-12.5,0,0,0,0.68,0.765,-12.5,-12.5,-12.5,0,-1,0,0.84,0.765],"f":[0,6,1,1,6,7,1,7,2,2,7,8,2,8,3,3,8,9,3,9,4,4,9,10,4,10,5,5,10,11,6,12,7,7,12,13,7,13,8,8,13,14,8,14,9,9,14,15,9,15,10,10,15,16,10,16,11,11,16,17,12,18,13,13,18,19,13,19,14,14,19,20,14,20,15,15,20,21,15,21,16,16,21,22,16,22,17,17,22,23,2,0,1,0,2,3,19,18,20,21,20,18]},
			{"name":"cube", "v":[-2.5,2.5,-2.5,0,0.848,-0.53,0,0,2.5,2.5,-2.5,0.349,0.625,-0.698,1,0,2.5,2.5,2.5,0.474,0.848,0.237,1,1,-2.5,2.5,2.5,-0.349,0.625,0.698,0,1,-2.5,2.5,-2.5,-1,0,0,0,0,-2.5,2.5,-2.5,0,0.848,-0.53,0,0,-2.5,0,-2.5,0,0,-1,0,0,2.5,0,-2.5,0.707,0,-0.707,0,0,2.5,0,2.5,0.707,0,0.707,0,0,-2.5,0,2.5,-0.707,0,0.707,0,0,-2.5,0,-2.5,-1,0,0,0,0,-2.5,0,-2.5,0,0,-1,0,0,-2.5,-2.5,-2.5,0,0,-1,0,0,2.5,-2.5,-2.5,0.894,0,-0.447,0,0,2.5,-2.5,2.5,0.447,0,0.894,0,0,-2.5,-2.5,2.5,-0.894,0,0.447,0,0,-2.5,-2.5,-2.5,-1,0,0,0,0,-2.5,-2.5,-2.5,0,0,-1,0,0,-2.5,-2.5,-2.5,0,-1,0,0,0,2.5,-2.5,-2.5,0,-1,0,0,0,2.5,-2.5,2.5,0,-1,0,0,0,-2.5,-2.5,2.5,0,-1,0,0,0,-2.5,-2.5,-2.5,0,0,0,0,0,-2.5,-2.5,-2.5,0,-1,0,0,0],"f":[0,6,1,1,6,7,1,7,2,2,7,8,2,8,3,3,8,9,3,9,4,4,9,10,4,10,5,5,10,11,6,12,7,7,12,13,7,13,8,8,13,14,8,14,9,9,14,15,9,15,10,10,15,16,10,16,11,11,16,17,12,18,13,13,18,19,13,19,14,14,19,20,14,20,15,15,20,21,15,21,16,16,21,22,16,22,17,17,22,23,2,0,1,0,2,3,19,18,20,21,20,18]},
			{"name":"cone", "v":[0,12.5,0,0.829,0.553,-0.087,0,0,0,12.5,0,0.829,0.553,0.087,0,0,0,12.5,0,0.793,0.553,0.258,0,0,0,12.5,0,0.722,0.553,0.417,0,0,0,12.5,0,0.619,0.553,0.558,0,0,0,12.5,0,0.49,0.553,0.674,0,0,0,12.5,0,0.339,0.553,0.761,0,0,0,12.5,0,0.173,0.553,0.815,0,0,0,12.5,0,0,0.553,0.833,0,0,0,12.5,0,-0.173,0.553,0.815,0,0,0,12.5,0,-0.339,0.553,0.761,0,0,0,12.5,0,-0.49,0.553,0.674,0,0,0,12.5,0,-0.619,0.553,0.558,0,0,0,12.5,0,-0.722,0.553,0.417,0,0,0,12.5,0,-0.793,0.553,0.258,0,0,0,12.5,0,-0.829,0.553,0.087,0,0,0,12.5,0,-0.829,0.553,-0.087,0,0,0,12.5,0,-0.793,0.553,-0.258,0,0,0,12.5,0,-0.722,0.553,-0.417,0,0,0,12.5,0,-0.619,0.553,-0.558,0,0,0,12.5,0,-0.49,0.553,-0.674,0,0,0,12.5,0,-0.339,0.553,-0.761,0,0,0,12.5,0,-0.173,0.553,-0.815,0,0,0,12.5,0,0,0.553,-0.833,0,0,0,12.5,0,0.173,0.553,-0.815,0,0,0,12.5,0,0.339,0.553,-0.761,0,0,0,12.5,0,0.49,0.553,-0.674,0,0,0,12.5,0,0.619,0.553,-0.558,0,0,0,12.5,0,0.722,0.553,-0.417,0,0,0,12.5,0,0.793,0.553,-0.258,0,0,0,12.5,0,0.829,0.553,-0.087,0,0,10,-2.5,0,0.995,-0.099,0,0,0,9.781,-2.5,2.079,0.973,-0.099,0.207,0,0,9.135,-2.5,4.067,0.909,-0.099,0.405,0,0,8.09,-2.5,5.878,0.805,-0.099,0.585,0,0,6.691,-2.5,7.431,0.666,-0.099,0.739,0,0,5,-2.5,8.66,0.498,-0.099,0.862,0,0,3.09,-2.5,9.511,0.307,-0.099,0.946,0,0,1.045,-2.5,9.945,0.104,-0.099,0.99,0,0,-1.045,-2.5,9.945,-0.104,-0.099,0.99,0,0,-3.09,-2.5,9.511,-0.308,-0.099,0.946,0,0,-5,-2.5,8.66,-0.498,-0.099,0.862,0,0,-6.691,-2.5,7.431,-0.666,-0.099,0.739,0,0,-8.09,-2.5,5.878,-0.805,-0.099,0.585,0,0,-9.135,-2.5,4.067,-0.909,-0.099,0.405,0,0,-9.781,-2.5,2.079,-0.973,-0.099,0.207,0,0,-10,-2.5,0,-0.995,-0.099,0,0,0,-9.781,-2.5,-2.079,-0.973,-0.099,-0.207,0,0,-9.135,-2.5,-4.067,-0.909,-0.099,-0.405,0,0,-8.09,-2.5,-5.878,-0.805,-0.099,-0.585,0,0,-6.691,-2.5,-7.431,-0.666,-0.099,-0.739,0,0,-5,-2.5,-8.66,-0.498,-0.099,-0.862,0,0,-3.09,-2.5,-9.511,-0.307,-0.099,-0.946,0,0,-1.045,-2.5,-9.945,-0.104,-0.099,-0.99,0,0,1.045,-2.5,-9.945,0.104,-0.099,-0.99,0,0,3.09,-2.5,-9.511,0.307,-0.099,-0.946,0,0,5,-2.5,-8.66,0.498,-0.099,-0.862,0,0,6.691,-2.5,-7.431,0.666,-0.099,-0.739,0,0,8.09,-2.5,-5.878,0.805,-0.099,-0.585,0,0,9.135,-2.5,-4.067,0.909,-0.099,-0.405,0,0,9.781,-2.5,-2.079,0.973,-0.099,-0.207,0,0,10,-2.5,0,0.995,-0.099,0,0,0,0,-12.5,0,0.705,-0.705,0.074,0,0,0,-12.5,0,0.674,-0.705,0.219,0,0,0,-12.5,0,0.614,-0.705,0.355,0,0,0,-12.5,0,0.527,-0.705,0.474,0,0,0,-12.5,0,0.417,-0.705,0.574,0,0,0,-12.5,0,0.288,-0.705,0.648,0,0,0,-12.5,0,0.147,-0.705,0.694,0,0,0,-12.5,0,0,-0.705,0.709,0,0,0,-12.5,0,-0.147,-0.705,0.694,0,0,0,-12.5,0,-0.288,-0.705,0.648,0,0,0,-12.5,0,-0.417,-0.705,0.574,0,0,0,-12.5,0,-0.527,-0.705,0.474,0,0,0,-12.5,0,-0.614,-0.705,0.355,0,0,0,-12.5,0,-0.674,-0.705,0.219,0,0,0,-12.5,0,-0.705,-0.705,0.074,0,0,0,-12.5,0,-0.705,-0.705,-0.074,0,0,0,-12.5,0,-0.674,-0.705,-0.219,0,0,0,-12.5,0,-0.614,-0.705,-0.355,0,0,0,-12.5,0,-0.527,-0.705,-0.474,0,0,0,-12.5,0,-0.417,-0.705,-0.574,0,0,0,-12.5,0,-0.288,-0.705,-0.648,0,0,0,-12.5,0,-0.147,-0.705,-0.694,0,0,0,-12.5,0,0,-0.705,-0.709,0,0,0,-12.5,0,0.147,-0.705,-0.694,0,0,0,-12.5,0,0.288,-0.705,-0.648,0,0,0,-12.5,0,0.417,-0.705,-0.574,0,0,0,-12.5,0,0.527,-0.705,-0.474,0,0,0,-12.5,0,0.614,-0.705,-0.355,0,0,0,-12.5,0,0.674,-0.705,-0.219,0,0,0,-12.5,0,0.705,-0.705,-0.074,0,0,0,-12.5,0,0.705,-0.705,0.074,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0,0,-12.5,0,0,0,0,0,0],"f":[0,31,1,1,31,32,1,32,2,2,32,33,2,33,3,3,33,34,3,34,4,4,34,35,4,35,5,5,35,36,5,36,6,6,36,37,6,37,7,7,37,38,7,38,8,8,38,39,8,39,9,9,39,40,9,40,10,10,40,41,10,41,11,11,41,42,11,42,12,12,42,43,12,43,13,13,43,44,13,44,14,14,44,45,14,45,15,15,45,46,15,46,16,16,46,47,16,47,17,17,47,48,17,48,18,18,48,49,18,49,19,19,49,50,19,50,20,20,50,51,20,51,21,21,51,52,21,52,22,22,52,53,22,53,23,23,53,54,23,54,24,24,54,55,24,55,25,25,55,56,25,56,26,26,56,57,26,57,27,27,57,58,27,58,28,28,58,59,28,59,29,29,59,60,29,60,30,30,60,61,31,62,32,32,62,63,32,63,33,33,63,64,33,64,34,34,64,65,34,65,35,35,65,66,35,66,36,36,66,67,36,67,37,37,67,68,37,68,38,38,68,69,38,69,39,39,69,70,39,70,40,40,70,71,40,71,41,41,71,72,41,72,42,42,72,73,42,73,43,43,73,74,43,74,44,44,74,75,44,75,45,45,75,76,45,76,46,46,76,77,46,77,47,47,77,78,47,78,48,48,78,79,48,79,49,49,79,80,49,80,50,50,80,81,50,81,51,51,81,82,51,82,52,52,82,83,52,83,53,53,83,84,53,84,54,54,84,85,54,85,55,55,85,86,55,86,56,56,86,87,56,87,57,57,87,88,57,88,58,58,88,89,58,89,59,59,89,90,59,90,60,60,90,91,60,91,61,61,91,92,62,93,63,63,93,94,63,94,64,64,94,95,64,95,65,65,95,96,65,96,66,66,96,97,66,97,67,67,97,98,67,98,68,68,98,99,68,99,69,69,99,100,69,100,70,70,100,101,70,101,71,71,101,102,71,102,72,72,102,103,72,103,73,73,103,104,73,104,74,74,104,105,74,105,75,75,105,106,75,106,76,76,106,107,76,107,77,77,107,108,77,108,78,78,108,109,78,109,79,79,109,110,79,110,80,80,110,111,80,111,81,81,111,112,81,112,82,82,112,113,82,113,83,83,113,114,83,114,84,84,114,115,84,115,85,85,115,116,85,116,86,86,116,117,86,117,87,87,117,118,87,118,88,88,118,119,88,119,89,89,119,120,89,120,90,90,120,121,90,121,91,91,121,122,91,122,92,92,122,123]}
		
			
			] 
			]]> ).toString();
			

			prep_texture();
			//trace(data);
			var shapes:Object = JSON.parse(data);
			
			trace("shapes=" + shapes.length);
			
			var vtx:Vector.<Number> = new Vector.<Number>(2400);
			var inx:Vector.<uint> =new Vector.<uint>(2400);
			
			
			var vz:uint = 12;
			var vi:uint = 0;
			var ii:uint = 0;
			
			var vvc:Vector3D =new Vector3D();
			for (var s:uint = 0; s < shapes.length; s++)
			{
				var ss:__shape3d = new __shape3d();
				
				
				var vc:uint = vi /vz;
				
				for (var v:uint = 0; v < shapes[s].v.length ; v=v+8)
				{
					var x:Number = Number(shapes[s].v[v]);
					var y:Number = Number(shapes[s].v[v + 1]);
					var z:Number = Number(shapes[s].v[v + 2]);
					
					var nx:Number = Number(shapes[s].v[v+3]);
					var ny:Number = Number(shapes[s].v[v + 4]);
					var nz:Number = Number(shapes[s].v[v + 5]);
					
					var tx:Number = Number(shapes[s].v[v + 6]);
					var ty:Number =Number(shapes[s].v[v + 7]);

					
				
					//xyz
					vtx[vi++] = x; vtx[vi++] = y; vtx[vi++] = z;vtx[vi++] = 1;
					
					//uv	
					vtx[vi++] =tx*4;
					vtx[vi++] =ty*4;				
					vtx[vi++] = 0;
					vtx[vi++] = 0;
					
					//nxnynz
					vvc.x = nx; vvc.y = ny; vvc.z = nz;
					//vvc.negate();
					vtx[vi++] = vvc.x ; vtx[vi++] = vvc.y; vtx[vi++] = vvc.z ;vtx[vi++] = 0;				
				
				
				
					
				}
				
				ss.istart = ii;
				
				
				for (var i:uint = 0; i < shapes[s].f.length; i++)
				{					
					inx[ii++] = vc + uint(shapes[s].f[i]);
				}
				ss.icount = shapes[s].f.length / 3;
				__shapes.push(ss);
			
				break;
			}
			
			
			trace("vi=" + vi + " |" +(vi / vz));
			
			idx	=__ctx.createIndexBuffer(ii);
			idx.uploadFromVector(inx, 0, ii);
			
			
			vbf = __ctx.createVertexBuffer(vi / vz, vz);					
			vbf.uploadFromVector(vtx, 0, vi / vz)
			
			
			
			
			for each(var sp:__shape3d in __shapes) {
				trace(sp.istart + "|" + sp.icount);		
			}
			
			//trace(vi+","+ii+" | "+__shapes.length);
			total_traingles = ii / 3;
			
			
			
		}
		
		//===========================
		private var vbf:VertexBuffer3D;
		private var idx:IndexBuffer3D;
		
		
	}

}
class __shape3d {
	public var istart:uint = 0;
	public var icount:uint = 0;
	
	
}