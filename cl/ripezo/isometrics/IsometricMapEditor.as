package cl.ripezo.isometrics {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import cl.ripezo.widgets.SideBar;
	
	import net.hires.debug.Stats;

	/**
	 * @author Ripezo
	 */

	public class IsometricMapEditor extends Sprite
	{
		private var _isometricLayer:IsometricLayer;
		private var _sideBar:SideBar;
		
		public function IsometricMapEditor()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;

			//DynamicAssets.loadAssets(initApplication);
			
			initApplication();
		}

		private function initApplication() : void
		{
			addIsometricLayer();
			//addSideBar();
			parent.addChild(new Stats());
		}

		private function addSideBar() : void
		{
			_sideBar = new SideBar();
			_sideBar.x = (stage.stageWidth - 300) - x;
			_sideBar.y = (100 - y);
			addChild(_sideBar);
		}

		private function addIsometricLayer() : void
		{
			_isometricLayer = new IsometricLayer();
			addChild(_isometricLayer);
		}
	}
}
