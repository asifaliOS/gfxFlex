package gfx.lib 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import gfx.lib.math;
	public class camera3d 
	{
		
		
		public 	var apply_pj_mat:int,compute_vw_port:int, compute_orientation:int,compute_vw_mat:int;
		
		public var yaw:int, pitch:int, roll:int;
		public var eye_x:Number, eye_y:Number, eye_z:Number; 
		public var forward_x:Number, forward_y:Number, forward_z:Number;
		public var up_x:Number, up_y:Number, up_z:Number;
		public var side_x:Number, side_y:Number, side_z:Number;
		public var near_plane:Number, far_plane:Number, aspect_ratio:Number, view_angle:Number;
		public var width:Number, height:Number;
		public var quat_0:Number, quat_1:Number, quat_2:Number, quat_3:Number;
		
		public var frustum_0:Number, frustum_1:Number, frustum_2:Number, frustum_3:Number, frustum_4:Number, frustum_5:Number, frustum_6:Number, frustum_7:Number, frustum_8:Number, frustum_9:Number, frustum_10:Number, frustum_11:Number, frustum_12:Number, frustum_13:Number, frustum_14:Number, frustum_15:Number, frustum_16:Number, frustum_17:Number, frustum_18:Number, frustum_19:Number, frustum_20:Number, frustum_21:Number, frustum_22:Number, frustum_23:Number;
		
		public var view :Matrix3D, projection:Matrix3D;
		
		public function camera3d() 
		{
		
	
		}
		
		public function set(ex:Number, ey:Number, ez:Number, _yaw:int, _pitch:int, _roll:int, _near_plane:Number, _far_plane:Number,  _view_angle:Number,_width:Number,_height:Number):void {
		
			width = _width;
			height = _height;
			eye_x = ex; eye_y = ey; eye_z = ez;
			yaw = _yaw; pitch = _pitch; roll = _roll;
			near_plane = _near_plane; far_plane = _far_plane; 
			aspect_ratio = width / height;
			view_angle = _view_angle;
			quat_0 = 0.0 ; quat_1 = 0.0 ; quat_2 = 0.0; quat_3 = 1.0;
			view = new Matrix3D();
			view.identity();
			projection = new Matrix3D();
			projection.identity();
			
			
			up_x = 0.0; up_y = 0.0; up_z = 0.0;
			forward_x = 0.0; forward_y = 0.0; forward_z = 0.0;
			
			side_x = 0.0; side_y = 0.0; side_z = 0.0;
			rotate(yaw, pitch, roll);
			 
			compute_orientation = 1;
            apply_pj_mat = 1;		
			
			perspectiveFieldOfViewLH();
			
			
		
		}
		
		public function front_back(speed:Number):void {
			
				eye_x=eye_x+forward_x*speed;
				eye_y=eye_y+forward_y*speed;
				eye_z=eye_z+forward_z*speed;
				compute_vw_mat =1;
		
		}
		public function rotate(_yaw:int, _pitch:int, _roll:int):void {
	        yaw = math.LIMIT_ANGLE(_yaw) ; 
			pitch = math.LIMIT_ANGLE(_pitch) ; 
			roll = math.LIMIT_ANGLE(_roll);
			
			
			forward_x = math._prec_cosf_05[roll];        //cos1
            forward_y = 1.0 * math._prec_sinf_05[roll]; //sin1

            forward_z = math._prec_cosf_05[pitch];        //cos2
            up_x = 1.0 * math._prec_sinf_05[pitch];      //sin2

            up_y = forward_x * forward_z;        //'w
            up_z = forward_x * up_x;        //'x

            side_x = forward_y * up_x ; //      'y
            side_y = forward_y * forward_z; //        'z

            forward_x = math._prec_cosf_05[yaw];//        'cos1
            forward_y = 1.0 * math._prec_sinf_05[yaw]; //    'sin1
			
			
			quat_3 = up_y * forward_x - side_x * forward_y;
            quat_0 = up_z * forward_x - side_y * forward_y;
            quat_1 = up_y * forward_y + side_x * forward_x;
            quat_2 = side_y * forward_x + up_z * forward_y;
			
			
			
			
			compute_orientation = 1;
			
			
			
		
		}
		
		public function perspectiveFieldOfViewRH():void {
			projection.copyRawDataFrom(Vector.<Number>([
				2.0*near_plane/width, 0.0, 0.0, 0.0,
				0.0, 2.0*near_plane/height, 0.0, 0.0,
				0.0, 0.0, far_plane/(near_plane-far_plane), -1.0,
				0.0, 0.0, near_plane*far_plane/(near_plane-far_plane), 0.0
			]));
		}
		
		public function perspectiveFieldOfViewLH():void {
			var yScale:Number = 1.0/Math.tan(view_angle/2.0);
			var xScale:Number = yScale / aspect_ratio; 
			projection.copyRawDataFrom  (Vector.<Number>([
				xScale, 0.0, 0.0, 0.0,
				0.0, yScale, 0.0, 0.0,
				0.0, 0.0, far_plane/(far_plane-near_plane), 1.0,
				0.0, 0.0, (near_plane*far_plane)/(near_plane-far_plane), 0.0
			]));
		}
		
		public function process():void {
			
			 if (apply_pj_mat == 1) {
				perspectiveFieldOfViewLH();

                compute_vw_port = 0;
                apply_pj_mat = 0 ;
			 }
			
			 var rawData:Vector.<Number>;
			 
			 if (compute_orientation == 1) {
				  rawData = view.rawData;
					  
				 //'calculation direction
                forward_x = 2.0 * (quat_0 * quat_2 - quat_3 * quat_1);
                forward_y = 2.0 * (quat_1 * quat_2 + quat_3 * quat_0);
                forward_z = 1.0 - 2.0 * (quat_0 * quat_0 + quat_1 * quat_1);

                up_x = math._prec_sinf[roll] ; 
				up_y = math._prec_cosf[roll] ; 
				up_z = 0.0;
                //'calculate UP and SIDE vectors by cross product

                side_x = forward_y * up_z - forward_z * up_y;
                side_y = forward_x * up_z + forward_z * up_x;
                side_z = forward_x * up_y - forward_y * up_x;

                up_x = side_y * forward_z - side_z * forward_y;
                up_y = side_x * forward_z + side_z * forward_x;
                up_z = side_x * forward_y - side_y * forward_x;
				
				// 11,12,13,14,21,22,23,24,31,32,33,34,41,42,43,44
				// 0   1 2   3  4 5   6  7  8  9 10 11 12 13 14 15
				//'calculation quaternion matrix
                rawData[3] = 0.0; rawData[7] = 0.0 ; rawData[11] = 0.0;


				
				
                math.sngTEMP_VAR_1 = quat_0 * quat_0;           //'x2
                math.sngTEMP_VAR_2 = quat_1 * quat_1;           //'y2
                math.sngTEMP_VAR_3 = quat_2 * quat_2;           //'z2
                math.sngTEMP_VAR_4 = quat_0 * quat_1;           //'xy
                math.sngTEMP_VAR_5 = quat_0 * quat_2;           //'xz
                math.sngTEMP_VAR_6 = quat_1 * quat_2;           //'yz
                math.sngTEMP_VAR_7 = quat_3 * quat_0;           //'wx
                math.sngTEMP_VAR_8 = quat_3 * quat_1;           //'wy
                math.sngTEMP_VAR_9 = quat_3 * quat_2;           //'wz
				
				
				
				
				
				rawData[0] = 1.0 - 2.0 * (math.sngTEMP_VAR_2 + math.sngTEMP_VAR_3);
                rawData[1] = 2.0 * (math.sngTEMP_VAR_4 + math.sngTEMP_VAR_9);
                rawData[2] = 2.0 * (math.sngTEMP_VAR_5 - math.sngTEMP_VAR_8);
                rawData[4] = 2.0 * (math.sngTEMP_VAR_4 - math.sngTEMP_VAR_9);
                rawData[5] = 1.0 - 2.0 * (math.sngTEMP_VAR_1 + math.sngTEMP_VAR_3);
                rawData[6] = 2.0 * (math.sngTEMP_VAR_6 + math.sngTEMP_VAR_7);
                rawData[8] = 2.0 * (math.sngTEMP_VAR_5 + math.sngTEMP_VAR_8);
                rawData[9] = 2.0 * (math.sngTEMP_VAR_6 - math.sngTEMP_VAR_7);
                rawData[10] = 1.0 - 2.0 * (math.sngTEMP_VAR_1 + math.sngTEMP_VAR_2);
				
				compute_vw_mat = 1;

                compute_orientation = 0;		
				view.rawData = rawData;
			 }
			 if (compute_vw_mat == 1) {
				  rawData = view.rawData;
				rawData[12] = ( -eye_x) * rawData[0] + ( -eye_y) * rawData[4] + ( -eye_z) * rawData[8];
                rawData[13] = ( -eye_x) * rawData[1] + ( -eye_y) * rawData[5] + ( -eye_z) * rawData[9];
                rawData[14] = ( -eye_x) * rawData[2] + ( -eye_y) * rawData[6] + ( -eye_z) * rawData[10];
                rawData[15] = 1.0;
				
				view.rawData = rawData;
			 }
			 

		}
		
	}

}