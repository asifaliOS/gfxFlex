package gfx.lib 
{
	/**
	 * ...
	 * @author ...
	 */
	import flash.geom.Matrix3D;
	import gfx.lib.math;
	
	 
	public class _3dobjectfast 
	{
		
		public function _3dobjectfast() 
		{
			sx = 1; sy = 1; sz = 1; tag = 0;
			rx = 0; ry = 0; rz = 0;
			mtx.identity();
			//mtx.appendTranslation(0, 0, 50);
			mat = mtx.rawData;
		}
	
			
		public var mat:Vector.<Number> ;
		
		public var rx:int, ry:int, rz:int;		
		public var sx:Number, sy:Number, sz:Number;
		
		
		public var tag:uint;
		
		public static var cosX:Number , sinX:Number , cosY:Number , sinY:Number , cosZ:Number , sinZ:Number;
		public static var mtx:Matrix3D=new Matrix3D();
		public function position(x:Number, y:Number, z:Number):void {
			mat[12] = x;
			mat[13] = y;
			mat[14] = z;
			
		}
		
		public function process():void {
			
			rx = math.LIMIT_ANGLE(rx); 
			ry = math.LIMIT_ANGLE(ry); 
			rz = math.LIMIT_ANGLE(rz); 
			
			cosX = math._prec_cosf[rx]; sinX = math._prec_sinf[rx]; 
			cosY = math._prec_cosf[ry]; sinY = math._prec_sinf[ry];
			cosZ = math._prec_cosf[rz]; sinZ = math._prec_sinf[rz];
			
			mat[0] =(cosY * cosZ + sinX * sinY * sinZ)*sx;
			mat[1] =(-cosX * sinZ)*sy;
			mat[2] =(sinX * cosY * sinZ - sinY * cosZ)*sz;
			mat[3] =0.0;

			mat[4] =(cosY * sinZ - sinX * sinY * cosZ)*sx;
			mat[5] =(cosX * cosZ)*sy;
			mat[6] =(-sinY * sinZ - sinX * cosY * cosZ)*sz;
			mat[7] =0.0;

			mat[8] =(cosX * sinY)*sx;
			mat[9] =sinX*sy;
			mat[10] =(cosX * cosY)*sz;
			mat[11] =0.0;
		
	
		}
	
	
	}

}