package gfx 
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import gfx.lib.engine;
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;

	public class shapes2d extends engine
	{
		
		
		[Embed (source = "../../sheet-1.png")] private var sheet_texture_class:Class;
		private var sheet_texture_bmp:Bitmap = new sheet_texture_class();
		// The Molehill Texture that uses the above myTextureData
		private var sheet_texture:Texture;
		public function shapes2d() 
		{
			
		}
		override public function ready():void 
		{
			
			prepare(stage.stageWidth, stage.stageHeight);
			load_data();
			
			default_shaders.upload(
			shaders_compiler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\nmov v0, va1\nmov v1, va1\n"),
			shaders_compiler.assemble(Context3DProgramType.FRAGMENT, "tex ft0, v1, fs0 <2d,repeat,miplinear>\nmov oc, ft0\n")
			);
						
			__ctx.setProgram(default_shaders);
			
			__ctx.setVertexBufferAt( 0, vbf, 0,Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
            __ctx.setVertexBufferAt( 1, vbf, 3, Context3DVertexBufferFormat.FLOAT_2 ); //va1 is color
		
			__ctx.setTextureAt(0, sheet_texture);
			//__ctx.setCulling( Context3DTriangleFace.BACK);
			
			
		}
		override public function render():void 
		{
			__ctx.clear(0, 0, 0, 0);
			var mt:Matrix3D = new Matrix3D();			
			mt.identity();
			mt.appendTranslation( 0, 0, 20);
			mt.append( projection);
			__ctx.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, mt, true );
			
			/*
			for each(var ss:__shape in __shapes) {
					__ctx.drawTriangles( idx, ss.istart, ss.icount);
			}
			*/
			__ctx.drawTriangles( idx, 0, this.total_traingles );
						
			
		}
		//=================================================
		private var __shapes:Vector.<__shape>=new Vector.<__shape>();
		private var total_traingles:uint = 0;
		
		private function load_data():void {
		
			
			var data:String = ( <![CDATA[
			[ 
			{"name":"box3", "x": 216.5835, "y": -53.4437, "vertices":[-38.502,-24.904,38.061, -25.051,38.502, 24.904,25.715,24.821, 23.291, -10.816 ,-21.345, -11.797 ,-25.226, 24.821, -38.502, 24.904], "indices":[0, 7, 6 ,0 ,6, 5, 0 ,5 ,4, 4, 3, 2 ,4 ,2 ,1, 4, 1, 0]},
			{"name":"box2", "x": 449.8165, "y": -347.0641, "vertices":[-16.277,-18.978,18.209,-18.978,3.322,18.296,-16.277,18.637], "indices":[0,3,2,2,1,0]},
			{"name":"box1", "x": -16.99797, "y": -373.3034, "vertices":[ -15.56, -25, 25, -25, 25, 25, -25, 25], "indices":[0, 3, 2, 2, 1, 0] }
			
		
			]
			]]> ).toString();
			
			
			
			
			
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
			
			
			
			
			
			
			
			var shapes:Object = JSON.parse(data);
			
			var vtx:Vector.<Number> = new Vector.<Number>(400);
			var inx:Vector.<uint> =new Vector.<uint>(400);
			
			
			
			var vz:uint = 5;
			var vi:uint = 0;
			var ii:uint = 0;
			var im_w:Number = 1024;
			var im_h:Number = 1024;
			var rt_x:Number = 512;
			var rt_y:Number = 512;
			
			
			for (var s:uint = 0; s < shapes.length; s++)
			{
				var ss:__shape = new __shape();
				
				var px:Number = Number(shapes[s].x + rt_x);
				var py:Number = Number(shapes[s].y + rt_y);
				
				var vc:uint = vi /vz;
				
				for (var v:uint = 0; v < shapes[s].vertices.length ; v=v+2)
				{
					var x:Number = Number(shapes[s].vertices[v]);
					var y:Number =Number(shapes[s].vertices[v + 1]);
					
				//	trace(x + "," + y);
					
					vtx[vi++] = x/10;
					vtx[vi++] = y/10;
					vtx[vi++] = 0;
					
					
					vtx[vi++] =  (px + x) / im_w;
					vtx[vi++] =  (py + y) / im_h;
				//	vtx[vi++] =  0;		
					
				}
				
				ss.istart = ii;
				
				
				for (var i:uint = 0; i < shapes[s].indices.length; i++)
				//for (var i:uint = shapes[s].indices.length - 1; i > -1; i--)
				{
					
					inx[ii] = vc + uint(shapes[s].indices[i]);
					var vp:uint = inx[ii]*vz;
					//trace("inx["+ii+"] = "+inx[ii]+" | "+vtx[vp]+","+vtx[vp+1]+","+vtx[vp+2]);
					ii++;
					
									
				}
				ss.icount = shapes[s].indices.length / 3;
				__shapes.push(ss);
				//trace("-----------------------------");
				//s = 100;
			
			}
			
			
			trace("vi=" + vi + " |" +(vi / vz));
			
			idx	=__ctx.createIndexBuffer(ii);
			idx.uploadFromVector(inx, 0, ii);
			
			
			vbf = __ctx.createVertexBuffer(vi / vz, vz);					
			vbf.uploadFromVector(vtx, 0, vi / vz)
			
			
			
			
			for each(var sp:__shape in __shapes) {
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
class __shape {
	public var istart:uint = 0;
	public var icount:uint = 0;
	
	
}