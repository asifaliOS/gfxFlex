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

	public class agl extends engine
	{
		
		override public function ready():void 
		{
			
			prepare(stage.stageWidth, stage.stageHeight);
			__ctx.enableErrorChecking = true;	
			

			
			
			
			
			default_shaders.upload(
			shaders_compiler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0"),
			shaders_compiler.assemble(Context3DProgramType.FRAGMENT, "mov ft0,fc0\nmov ft1,fc1\ndp3 ft2,ft0,ft1\nmov oc, ft2")
			);
			
			
			__ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 0]))
			
			__ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.4, 0.7, 1, 0]))
			
			
			__ctx.setProgram(default_shaders);
			
			
			var vertexData:Vector.<Number> = Vector.<Number>( [-1,-1,0,-1,1,0,1,1,0,1,-1,0]  );
			var triangles:Vector.<uint> = Vector.<uint>([0,1,2,0,2,3]);
			
			
			vbf = __ctx.createVertexBuffer( vertexData.length/3, 3);					
			vbf.uploadFromVector( vertexData, 0, vertexData.length / 3 );
		
			idx	=__ctx.createIndexBuffer(triangles.length);
			idx.uploadFromVector(triangles,0, triangles.length);
			
			
			total_traingles = triangles.length/3;
		
			
			
			__ctx.setVertexBufferAt( 0, vbf, 0, Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
			
			
		}
		override public function render():void 
		{
			__ctx.clear(0, 0, 1, 0);
			
			
			var mt:Matrix3D = new Matrix3D();			
			mt.identity();
			
			mt.appendTranslation( 0, 0, 5);
			mt.append( projection);
			__ctx.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, mt, true );
			

			
			__ctx.drawTriangles( idx, 0, total_traingles );
		}
		//=================================================
		private var total_traingles:uint = 0;
			
		//===========================
		private var vbf:VertexBuffer3D;
		private var idx:IndexBuffer3D;
		
		
	}

}
