package cl.ripezo.utilities
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;
	/**
	 * @author Ripezo
	 */
	public class Snippets
	{
		public static function lerp(value:Number, min:Number, max:Number):Number
		{
			return (max - min) * value + min;
		}
		
		public static function norm(value:Number, min:Number, max:Number):Number
		{
			return (value - min) / (max - min);
		}
		
		public static function convertDegreeToRadians(grados:Number):Number
		{
			return grados * (Math.PI / 180);
		}
		
		public static function convertRadiansToDegree(radianes:Number):Number
		{
			return radianes * (180 / Math.PI);
		}

		public static function getAlphaColorTransform(color:uint, alpha:Number):ColorTransform
		{
			var aRGB:ColorTransform = new ColorTransform(1-alpha,1-alpha,1-alpha,1.0,color>>16&0xFF*alpha,color >>8&0xFF*alpha,color&0xFF*alpha);
			return aRGB;
		}
		
		public function getChildrenOf(target:DisplayObjectContainer):Array
		{
		   var children:Array = [];
		
		   for (var i:uint = 0; i < target.numChildren; i++)
		      children.push(target.getChildAt(i));
		
		   return children;
		}
	}
}
