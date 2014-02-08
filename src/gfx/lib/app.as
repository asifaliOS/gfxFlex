package gfx.lib 
{
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	
	
	
	include "imports.as";
	
	
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	
	/**
	 * ...
	 * @author asif
	 */
	public class app extends Sprite
	{
		
		
		// Context 3D instance
		public var __ctx:Context3D;
		public var shaders_compiler:agal = new agal();
		
		public var default_shaders:Program3D;
		
		public var _width:Number;
		public var _height:Number;
		
		private var indexList:IndexBuffer3D;
        private var vertexes:VertexBuffer3D;
		private var projection:pmatrix3d = new pmatrix3d();
		
		public function app() 
		{
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, on_context_init);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
			
			
			
		}
		
		public function ready():void
		{
			prepare(stage.stageWidth, stage.stageHeight);
		}
		
		public function render():void
		{
			
		}
		
		public function prepare(_width:Number,_height:Number):void
		{
			__ctx.configureBackBuffer( _width, _height, 2, true);	
			
			//__ctx.setCulling( Context3DTriangleFace.BACK );
			
			//Create vertex index list for the triangles forming a cube
            var triangles:Vector.<uint> = Vector.<uint>( [ 
                2,1,0, //front face
                3,2,0,
                4,7,5, //bottom face
                7,6,5,
                8,11,9, //back face
                9,11,10,
                12,15,13, //top face
                13,15,14,
                16,19,17, //left face
                17,19,18,
                20,23,21, //right face
                21,23,22
            ] );
            indexList = __ctx.createIndexBuffer( triangles.length );
            indexList.uploadFromVector( triangles, 0, triangles.length );
            
            //Create vertexes - cube faces do not share vertexes
            const dataPerVertex:int = 6;
            var vertexData:Vector.<Number> = Vector.<Number>(
                [
                    // x,y,z r,g,b format
                    0,0,0, 1,0,0, //front face
                    0,1,0, 1,0,0,
                    1,1,0, 1,0,0,
                    1,0,0, 1,0,0,
                    
                    0,0,0, 0,1,0, //bottom face
                    1,0,0, 0,1,0,
                    1,0,1, 0,1,0,
                    0,0,1, 0,1,0,
                    
                    0,0,1, 1,0,0, //back face
                    1,0,1, 1,0,0,
                    1,1,1, 1,0,0,
                    0,1,1, 1,0,0,
                    
                    0,1,1, 0,1,0, //top face
                    1,1,1, 0,1,0,
                    1,1,0, 0,1,0,
                    0,1,0, 0,1,0,
                    
                    0,1,1, 0,0,1, //left face
                    0,1,0, 0,0,1,
                    0,0,0, 0,0,1,
                    0,0,1, 0,0,1,
                    
                    1,1,0, 0,0,1, //right face
                    1,1,1, 0,0,1,
                    1,0,1, 0,0,1,
                    1,0,0, 0,0,1
                ]
            );
            vertexes = __ctx.createVertexBuffer( vertexData.length/dataPerVertex, dataPerVertex );
            vertexes.uploadFromVector( vertexData, 0, vertexData.length/dataPerVertex );
            
            //Identify vertex data inputs for vertex program
            __ctx.setVertexBufferAt( 0, vertexes, 0, Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
            __ctx.setVertexBufferAt( 1, vertexes, 3, Context3DVertexBufferFormat.FLOAT_3 ); //va1 is color
            
			
			
			
			
			
			
			
			default_shaders = __ctx.createProgram();
			
			default_shaders.upload(
			shaders_compiler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\nmov v0, va1"),
			shaders_compiler.assemble(Context3DProgramType.FRAGMENT, "mov oc, v0")
			);
			
			
			__ctx.setProgram(default_shaders);
			
			
			
			// Use a helper function to set up the projection
			projection.perspectiveFieldOfViewLH(45*Math.PI/180, 1.2, 0.1, 512);
			// Set the projection matrix as a vertex program constant, this is what we access in vertex shader register vc0
			__ctx.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, projection, true);
			// Set the out color for our polygon as fragment program constant, this is what we access in fragment shader register fc0
			__ctx.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 0]));
			// Hook up enter frame event where we will do our rendering
			addEventListener(Event.ENTER_FRAME, on_render_internal)
		}
		private var ry:Number = 0;
		private function on_render_internal(event:Event):void {
			// Clear up the context
			__ctx.clear(0, 0, 0, 0);
			var mt:Matrix3D = new Matrix3D();
			var mv:Matrix3D=new Matrix3D();

			mt.identity();
			mv.identity();
			mv.appendRotation( ry, Vector3D.Y_AXIS);
			mv.appendRotation( ry, Vector3D.Z_AXIS);
			mv.appendTranslation( 0, -.5, 5);
			if (ry > 359) ry = 0; else ry++;
			
			
			mt.append(mv);
			mt.append(projection);
			__ctx.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, mt, true );
			
			//__ctx.setProgramConstantsFromMatrix(
			// Draw the index buffer
			
			__ctx.drawTriangles( indexList, 0, 12 );
			
			render();
			// Present it
			__ctx.present();
		}
		
		private function on_context_init(event:Event):void {
			
			var stage3D:Stage3D = event.target as Stage3D;
			__ctx = stage3D.context3D;
			
			ready();
		}
		
		
		
		
		
	}
	

}

/*

 Function MV2(v As Single) As String

        If v < 0 Then

            Return Format(Math.Round(Math.Abs(v), 4), "-#0.####")
        Else
            Return Format(Math.Round(v, 4), "#0.####")
        End If



    End Function
    Private Sub btnJson_Click(sender As Object, e As EventArgs) Handles btnJson.Click
        Dim sb As New System.Text.StringBuilder

        sb.Append("{""n"":""name"",""v"":[")

        Dim comma As String = ""
        For i As Integer = 0 To total_vertices - 1

            sb.Append(comma)
            sb.Append(MV2(mesh_vertices(i).x) & "," & MV2(mesh_vertices(i).y) & "," & MV2(mesh_vertices(i).z))

            sb.Append("," & MV2(mesh_vertices(i).nx) & "," & MV2(mesh_vertices(i).ny) & "," & MV2(mesh_vertices(i).nz))

            sb.Append("," & MV2(mesh_vertices(i).tx) & "," & MV2(mesh_vertices(i).ty))
            comma = ","
        Next
        comma = ""
        sb.Append("],""f"":[")



        For i As Integer = 0 To total_faces - 1
            sb.Append(comma)
            sb.Append(mesh_faces(i).v1 & "," & mesh_faces(i).v2 & "," & mesh_faces(i).v3)
            comma = ","
            
        Next

        sb.Append("]}")

        Clipboard.SetText(sb.ToString)
        sb = Nothing

    End Sub
	
	*/