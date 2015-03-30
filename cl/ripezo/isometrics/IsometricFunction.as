package cl.ripezo.isometrics {
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * @author Ripezo
	 */
	public class IsometricFunction
	{
		public static var entitySize:uint = 200;

		public static function cartesianToIsometric(cartesianPoint:Point):Point
		{
			var isometricPoint:Point = new Point();
			isometricPoint.x = -((cartesianPoint.y / (entitySize >> 2)) - (cartesianPoint.x / (entitySize >> 1))) >> 1;
			isometricPoint.y = ((cartesianPoint.y / (entitySize >> 2)) + (cartesianPoint.x / (entitySize >> 1))) >> 1;
			return isometricPoint;
		}
		
		public static function isometricToCartesian(isometricPoint:Point):Point
		{
			var cartesianPoint:Point = new Point();
			cartesianPoint.x = (isometricPoint.x + isometricPoint.y) * (entitySize >> 1);
			cartesianPoint.y = -(isometricPoint.x - isometricPoint.y) * (entitySize >> 2);
			return cartesianPoint;
		}
		
		public static function sortEntities(target:DisplayObjectContainer):void
	    {
	        var children:Array = getAllEntities(target);
			children.sort(sortArray);
			
			for (var b:uint = 0; b < target.numChildren; b++)
			{
				target.setChildIndex(children[b], target.numChildren - 1);
			}
	    }
		
		public static function sortArray(a:IsometricEntity, b:IsometricEntity):int
	    {
	        var aValue:Number = ((a.isometricsCoords.y + a.isometricsCoords.x) * 1) + ((a.isometricsCoords.y - a.isometricsCoords.x) * 100) + (a.y * 10000);
	        var bValue:Number = ((b.isometricsCoords.y + b.isometricsCoords.x) * 1) + ((b.isometricsCoords.y - b.isometricsCoords.x) * 100) + (b.y * 10000);
	
	        return (aValue >= bValue) ? 1 : -1;
	    }
		
		public static function getAllEntities(target:DisplayObjectContainer):Array
		{
			var children:Array = [];
			
			for (var i:uint = 0; i < target.numChildren; i++)
			{
				children.push(target.getChildAt(i));
			}
			
			return children;
		}
		
		public static function getLowerPoint(a : Point, b : Point):Point
		{
			var menorX:int;
			var menorY:int;
			
			if(a.x < b.x)
			{
				menorX = a.x;
			}
			else
			{
				menorX = b.x;
			}
			
			if(a.y < b.y)
			{
				menorY = a.y;
			}
			else
			{
				menorY = b.y;
			}
			
			return new Point(menorX, menorY);
		}
		
		public static function getGreaterPoint(a : Point, b : Point):Point
		{
			var mayorX:int;
			var mayorY:int;
			
			if(a.x < b.x)
			{
				mayorX = b.x;
			}
			else
			{
				mayorX = a.x;
			}
			
			if(a.y < b.y)
			{
				mayorY = b.y;
			}
			else
			{
				mayorY = a.y;
			}
			
			return new Point(mayorX, mayorY);
		}
		
	}
}
