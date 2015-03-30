package cl.ripezo.isometrics {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author Ripezo
	 */
	public class IsometricLayer extends Sprite
	{
		private var _isometricCoords:Point = new Point();
		private var _isDragEnabled:Boolean = false;
		
		// Selection
		private var _isSelectionToolEnabled:Boolean = true;
		private var _currentSelection:Array;
		private var _addSelectionBuffer:Array;
		private var _removeSelectionBuffer:Array;
		private var _addSelection:Boolean = false;
		private var _removeSelection:Boolean = false;
		private var _isMultipleSelection:Boolean = false;
		private var _startSelectionPoint:Point;
		private var _endSelectionPoint:Point;
		
		public function IsometricLayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			createPlatform(16,16);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}
		
		private function runSelectionTool():void
		{
			if(_startSelectionPoint)
			{
				_endSelectionPoint = getIsometricMouseCoords();

				if(_removeSelection)
				{
					generateRemoveSelectionBuffer(_startSelectionPoint, _endSelectionPoint);
				}
				else
				{
					generateSelectionBuffer(_startSelectionPoint, _endSelectionPoint);
				}
			}
			else
			{
				trace('_startSelectionPoint no está definido.');
			}
		}
		
		private function stopSelectionTool():void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			
			if(_isDragEnabled)
			{
				
			}
			else if(_isSelectionToolEnabled)
			{
				if(!_addSelection && !_removeSelection)
				{
					if(_addSelectionBuffer && _addSelectionBuffer.length)
					{
						deleteSelection();
						_currentSelection = new Array();
					}
				}
				
				if(_removeSelection)
				{
					removeSelection(_removeSelectionBuffer);
				}
				else
				{
					pushSelection(_addSelectionBuffer);
				}
				
			}
		}

		private function onMouseDownHandler(event:MouseEvent):void
		{
			if(_isDragEnabled)
			{
				initDrag();
			}
			else if(_isSelectionToolEnabled)
			{
				_startSelectionPoint = getIsometricMouseCoords();
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				
				if(!_removeSelection && !_addSelection)
				{
					deleteSelection();
					_currentSelection = new Array();
				}
				runSelectionTool();
			}
		}

		private function onMouseMoveHandler(event:MouseEvent):void
		{
			if(_isDragEnabled)
			{

			}
			else if(_isSelectionToolEnabled)
			{
				
				if(!_removeSelection && !_addSelection)
				{
					deleteSelection();
					_currentSelection = new Array();
				}
				
				runSelectionTool();
			}
		}

		private function onRollOutHandler(event:MouseEvent):void
		{
			stopSelectionTool();
			trace('OUT');
		}

		private function onMouseUpHandler(event : MouseEvent) : void
		{
			cancelDrag();
			stopSelectionTool();
			trace('UP');
		}

		private function onMouseLeaveHandler(event : Event) : void
		{
			cancelDrag();
			stopSelectionTool();
			trace('Leave');
		}
		
		private function generateSelectionBuffer(a:Point, b:Point):void
		{
			var start:Point = IsometricFunction.getLowerPoint(a, b);
			var end:Point = IsometricFunction.getGreaterPoint(a, b);
			var entityReference:IsometricEntity;
			
			if(_addSelectionBuffer)
			{
				for each (entityReference in _addSelectionBuffer) 
				{
					entityReference.isSelected = false;
				}
			}

			_addSelectionBuffer = new Array();
			for(var fila:int = start.y; fila <= end.y; fila++)
			{
				for(var columna:int = start.x; columna <= end.x; columna++)
				{
					entityReference = getChildByName(columna + 'x' + fila) as IsometricEntity;
					if(!isAlreadySelected(entityReference, _currentSelection))
					{
						entityReference.isSelected = true;
						_addSelectionBuffer.push(entityReference);
					}
				}
			}
		}

		private function generateRemoveSelectionBuffer(a:Point, b:Point):void
		{
			var start:Point = IsometricFunction.getLowerPoint(a, b);
			var end:Point = IsometricFunction.getGreaterPoint(a, b);
			var entityReference:IsometricEntity;

			_removeSelectionBuffer = new Array();
			for(var fila:int = start.y; fila <= end.y; fila++)
			{
				for(var columna:int = start.x; columna <= end.x; columna++)
				{
					entityReference = getChildByName(columna + 'x' + fila) as IsometricEntity;
					if(isAlreadySelected(entityReference, _currentSelection))
					{
						entityReference.isSelected = false;
						_removeSelectionBuffer.push(entityReference);
					}
				}
			}
		}

		private function pushSelection(selection:Array):void
		{
			if(selection)
			{
				for(var a:int = 0; a < selection.length; a++)
				{
					if(!isAlreadySelected(selection[a], _currentSelection))
					{
						if(!_currentSelection) _currentSelection = new Array();
						_currentSelection.push(selection[a]);
						selection[a].isSelected = true;
					}
				}
			}
			else
			{
				trace('No existe preselección.');
			}
			
			_addSelectionBuffer = new Array();
			_startSelectionPoint = null;
			_endSelectionPoint = null;
		}
		
		private function removeSelection(selection:Array):void
		{
			for(var a:int = 0; a < selection.length; a++)
			{
				for(var b:int = 0; b < _currentSelection.length; b++)
				{
					if(selection[a] == _currentSelection[b])
					{
						_currentSelection[b].isSelected = false;
						_currentSelection.splice(b, 1);
					}
				}
			}
			
			_removeSelectionBuffer = new Array();
			_startSelectionPoint = null;
			_endSelectionPoint = null;
		}

		private function isAlreadySelected(element:IsometricEntity, group:Array):Boolean
		{
			var isSuccess:Boolean = false;
			
			if(_currentSelection)
			{
				var totalElement:uint = _currentSelection.length;
				for(var i:int = 0; i < totalElement; i++)
				{
					if(_currentSelection[i] == element)
					{
						isSuccess = true;
						break;
					}
				}
			}
			
			return isSuccess;
		}

		private function initDrag() : void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveHandler);
		}
		
		private function cancelDrag():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveHandler);
			stopDrag();
			onResizeHandler();
		}

		private function createPlatform(rows : uint, columns : uint) : void
		{
			for(var row:uint = 0; row < rows; row++)
			{
				for(var column:uint = 0; column < columns; column++)
				{
					var isometricEntity:IsometricEntity = new IsometricEntity();
					isometricEntity.isometricsCoords = new Point(column, row);
					addChild(isometricEntity);
				}
			}
			
			IsometricFunction.sortEntities(this);
		}
		
		public function drawDefaultGrid():void
		{
			var columnas:uint = Math.ceil(stage.stageWidth / IsometricFunction.entitySize);
			var filas:uint = Math.ceil(stage.stageHeight / (IsometricFunction.entitySize >> 2));

			for(var row:uint = 0; row < filas; row++)
			{
				for(var column:uint = 0; column < columnas; column++)
				{
					var isometricEntity:IsometricEntity = new IsometricEntity();
					var cartesianCoords:Point = new Point(column * IsometricFunction.entitySize, row * (IsometricFunction.entitySize >> 2));
					addChild(isometricEntity);
					isometricEntity.isometricsCoords = IsometricFunction.cartesianToIsometric(cartesianCoords);
				}
			}
			
			IsometricFunction.sortEntities(this);
		}

		private function traceSelection(selectionGroup:Array):void
		{
			trace('Current Selection:');
			for each (var entity:IsometricEntity in selectionGroup) 
			{
				//entity.isSelected = true;
				trace(entity.isometricsCoords.x, entity.isometricsCoords.y);
			}
		}

		private function deleteSelection():void
		{
			for each (var entity:IsometricEntity in IsometricFunction.getAllEntities(this)) 
			{
				entity.isSelected = false;
			}
		}
		
		private function onKeyDownHandler(event:KeyboardEvent):void
		{
			trace('KeyCode:', event.keyCode);
			
			switch(event.keyCode)
			{
				case 15:
				{
					_addSelection = true;
					break;
				}
					
				case 18:
				{
					_removeSelection = true;
					break;
				}
					
				case 32:
				{
					_isDragEnabled = true;
					buttonMode = true;
					break;
				}
					
				default:
				{
					
					break;
				}
			}
		}
		
		private function onKeyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 15:
				{
					_addSelection = false;
					break;
				}
					
				case 18:
				{
					_removeSelection = false;
					break;
				}
					
				case 32:
				{
					_isDragEnabled = false;
					buttonMode = false;
					break;
				}
					
				default:
				{
					trace('KeyCode:', event.keyCode);
					break;
				}
			}
		}
		
		public function getCartesianMouseCoords():Point
		{
			return new Point(mouseX + (IsometricFunction.entitySize >> 1), mouseY);
		}
		
		public function getIsometricMouseCoords():Point
		{
			return IsometricFunction.cartesianToIsometric(new Point(getCartesianMouseCoords().x, getCartesianMouseCoords().y));
		}
		
		public function onResizeHandler():void
		{
			
		}
	}
}
