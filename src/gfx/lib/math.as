package gfx.lib 
{
	
	public class math 
	{
		public static var sngTEMP_VAR_0:Number, sngTEMP_VAR_1:Number, sngTEMP_VAR_2:Number, sngTEMP_VAR_3:Number, sngTEMP_VAR_4:Number, sngTEMP_VAR_5:Number, sngTEMP_VAR_6:Number, sngTEMP_VAR_7:Number, sngTEMP_VAR_8:Number, sngTEMP_VAR_9:Number, sngTEMP_VAR_10:Number, sngTEMP_VAR_11:Number, sngTEMP_VAR_12:Number, sngTEMP_VAR_13:Number, sngTEMP_VAR_14:Number, sngTEMP_VAR_15:Number, sngTEMP_VAR_16:Number;
		public static var intTEMP_VAR_0:int, intTEMP_VAR_1:int;
		
		
		public static const DEG_TO_RAD_HELP:Number = 0.017453292519943295;
		public static const _360DEGRAD:Number = 360 * DEG_TO_RAD_HELP;
		public static const _1DEGRAD:Number = 1 * DEG_TO_RAD_HELP;
		public static const RAD_TO_DEG_HELP:Number = 57.295779513082323;
		
		
		public static const ANGLES_ACCURACCY:int = 10;
		public static const MAX_ANGLES:int = 360 * ANGLES_ACCURACCY;
		public static const ANGLES_LIMIT:int = (MAX_ANGLES - ANGLES_ACCURACCY);
	
		
		
		public static var _prec_cosf:Vector.<Number> = new Vector.<Number>(MAX_ANGLES);
		
		public static var _prec_sinf:Vector.<Number> = new Vector.<Number>(MAX_ANGLES);
		public static var _prec_cosf_05:Vector.<Number> = new Vector.<Number>(MAX_ANGLES);
		public static var _prec_sinf_05:Vector.<Number> = new Vector.<Number>(MAX_ANGLES);
		
		public static function INIT():void {
			
			
			var ax:Number = 0;
			var ad:Number = 1.0 / Number(ANGLES_ACCURACCY);
			
			for (var i:uint = 0; i < MAX_ANGLES; i++)
			{
				var a:Number = ax * DEG_TO_RAD_HELP;
				_prec_cosf[i] = Number(Math.cos(a));
				_prec_sinf[i] = Number(Math.sin(a));

                _prec_cosf_05[i] = Number(Math.cos(a * 0.5));
                _prec_sinf_05[i] = Number(Math.sin(a * 0.5));
                ax = ax + ad;
			}
			
			
		}
		
		public static function LIMIT_ANGLE(a:int):int {
			if (a < 0) a = ANGLES_LIMIT + a;
			if (a > ANGLES_LIMIT) a = a - ANGLES_LIMIT;
			return(a);
		}
	}

}