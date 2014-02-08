package gfx.lib 
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;	
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import gfx.lib.math;
	
	public class shapes_manager 
	{
		public var templates:Vector.<shape_template>=new Vector.<shape_template>();
		
		public var shaders:Program3D;
		public var vbf:VertexBuffer3D;
		public var idx:IndexBuffer3D;
		private var texture:Texture;
		public var tw:int, th:int, total_traingles:int;
		public var ctx:Context3D;
		
		public function shapes_manager(_ctx:Context3D) 
		{
			ctx = _ctx;
			
			var shaders_compiler:agal = new agal();
			shaders = ctx.createProgram();
			shaders.upload(
			shaders_compiler.assemble(Context3DProgramType.VERTEX, "m33 vt0.xyz,va2.xyz,vc0\nnrm vt1.xyz,vt0.xyz\ndp3 vt0.x,vt1.xyz,vc9.xyz\nmax vt0.y,vt0.x,vc9.w\nm44 op,va0,vc0\nmul v0,vt0.y,vc8\nmov v1,va1"),
			shaders_compiler.assemble(Context3DProgramType.FRAGMENT,"tex ft0,v1.xy,fs0 <2d,linear,wrap,miplinear>\nmul ft1,ft0,v0\nmul ft2,ft0,fc0\nadd ft1,ft1,ft2\nsat oc,ft1")
			);
			shaders_compiler = null;
			
			
			
		}
		public function ready_render():void {
			
			ctx.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, Vector.<Number>([1,1,1,0]));
			ctx.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, Vector.<Number>([-0.0,0.0,-0.8,0]));
			ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.1, 0.1, 0.1, 1]));
			
			ctx.setVertexBufferAt( 0, vbf, 0, Context3DVertexBufferFormat.FLOAT_4);
			ctx.setVertexBufferAt( 1, vbf, 4, Context3DVertexBufferFormat.FLOAT_2 ); 
			ctx.setVertexBufferAt( 2, vbf, 8, Context3DVertexBufferFormat.FLOAT_4); 
			ctx.setProgram(shaders);
			ctx.setTextureAt(0, texture);	
		}
		
		public function draw_template(i:uint, matrix:Matrix3D):void {
			
			ctx.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, matrix, true );
			ctx.drawTriangles( idx,templates[i].istart, templates[i].icount);
		}
		
		public function prepare_texture(bmp:Bitmap):void {
				
			// Generate mipmaps
			var ws:int = bmp.bitmapData.width;
			var hs:int = bmp.bitmapData.height;
			tw = ws; th = hs;
			texture =ctx.createTexture(ws, hs,Context3DTextureFormat.BGRA, false);
			
			var level:int = 0; var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			while ( ws >= 1 && hs >= 1 ) {
			tmp.draw(bmp.bitmapData, transform, null, null,
			null, true);
			texture.uploadFromBitmapData(tmp, level);
			transform.scale(0.5, 0.5); level++; ws >>= 1; hs >>= 1;
			if (hs && ws) {
			tmp.dispose();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			}
			}
			tmp.dispose();
		}
		public function load_3d_shapes(textimage:Bitmap, shapesdata:String):void {
			
			prepare_texture(textimage);
			
			var shapes:Object = JSON.parse(shapesdata);
			var vtx:Vector.<Number> = new Vector.<Number>(2400);
			var inx:Vector.<uint> = new Vector.<uint>(2400);
			
			var vz:uint = 12;
			var vi:uint = 0;
			var ii:uint = 0;
			
			
			for (var s:uint = 0; s < shapes.length; s++)
			{
				var ss:shape_template = new shape_template();
				
				
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
					vtx[vi++] = tx;vtx[vi++] = ty;				
					vtx[vi++] = 0;vtx[vi++] = 0;
					
					//nxnynz
					vtx[vi++] = nx; vtx[vi++] = ny; vtx[vi++] = nz;vtx[vi++] = 0;				
				
					
				}
				
				ss.istart = ii;
				
				
				for (var i:uint = 0; i < shapes[s].f.length; i++)
				{					
					inx[ii++] = vc + uint(shapes[s].f[i]);
				}
				ss.icount = shapes[s].f.length / 3;
				templates.push(ss);
			
				
			}
		
			
			idx	=ctx.createIndexBuffer(ii);
			idx.uploadFromVector(inx, 0, ii);
			
			
			vbf = ctx.createVertexBuffer(vi / vz, vz);					
			vbf.uploadFromVector(vtx, 0, vi / vz)
			
			
			total_traingles = ii / 3;
		}
		
		
		
		
	}

}
class shape_template {
	public var istart:uint = 0;
	public var icount:uint = 0;
	
	
}