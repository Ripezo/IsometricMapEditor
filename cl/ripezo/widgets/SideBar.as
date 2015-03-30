package cl.ripezo.widgets {
	import cl.ripezo.isometrics.IsometricEntity;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author Ripezo
	 */
	public class SideBar extends Sprite
	{
		private var _entityPreview:IsometricEntity;
		
		public function SideBar()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			updateEnityPreview();
			
			addEventListeners();
			
			onResizeHandler();
		}

		private function updateEnityPreview() : void
		{
			if(_entityPreview)
			{
				removeChild(_entityPreview);
				_entityPreview = null;
			}
			
			_entityPreview = new IsometricEntity();
			_entityPreview.addTexture(1);
			_entityPreview.scaleX = _entityPreview.scaleY = .5;
			addChild(_entityPreview);
		}

		private function addEventListeners() : void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		}

		private function initDrag(event : MouseEvent) : void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveHandler);
		}

		private function onMouseUpHandler(event : MouseEvent) : void {cancelDrag();}
		private function onMouseLeaveHandler(event : Event) : void {cancelDrag();}
		
		private function cancelDrag():void
		{
			if(x < 0) x = 0;
			if(y < 0) y = 0;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveHandler);
			stopDrag();
			onResizeHandler();
		}

		private function drawBackground():void
		{
			graphics.clear();
			
			graphics.lineStyle(1, 0xEEEEEE);
			graphics.beginFill(0xF0F0F0);
			//graphics.drawRect(0, 0, stage.stageWidth - x, stage.stageHeight - y);
			graphics.drawRoundRect(0, 0, stage.stageWidth - x, stage.stageHeight - y, 20, 20);
			graphics.endFill();
		}
		
		public function onResizeHandler():void
		{
			drawBackground();
			
			x = ((x) >> 0) + .5;
			y = ((y) >> 0) + .5;
			
			if(_entityPreview)
			{
				_entityPreview.x = ((stage.stageWidth - x) >> 1) >> 0;
			}
		}
	}
}
