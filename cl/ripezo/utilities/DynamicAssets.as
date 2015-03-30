package cl.ripezo.utilities {
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	/**
	 * @author Ripezo
	 */
	public class DynamicAssets
	{
		public static var data:Object;
		
		public static function loadAssets(callbackFunction:Function):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = 'data.json';
			loader.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				var loader:URLLoader = URLLoader(event.target);
				data = JSON.parse(loader.data);
				if(callbackFunction != null) callbackFunction();
			});
			loader.load(request);
		}
	}
}
