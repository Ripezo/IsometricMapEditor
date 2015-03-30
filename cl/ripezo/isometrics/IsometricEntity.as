package cl.ripezo.isometrics
{
	import com.greensock.TweenMax;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.data.ImageLoaderVars;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @author Ripezo
	 */
	
	public class IsometricEntity extends Sprite
	{
		private var _instance:IsometricEntity;
		private var _isometricCoords:Point = new Point();
		private var _cartesianCoords:Point = new Point();
		private var _textureID:uint = 0;
		private var _pointer:Shape;
		private var _showPointer:Boolean = true;
		private var _isSelected:Boolean = false;
		private var _isMouseOver:Boolean = false;
		private var _isometricCoordsTF:TextField;
		
		private var _imageLoader:ImageLoader;
		
		// Settings
		private var _showIsometricCoords:Boolean = false;
		
		public function IsometricEntity()
		{
			_instance = this;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			addTexture();
			
			addEventListeners();
		}
		
		private function addEventListeners():void
		{
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			//this.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
		}

		private function setPosition(isometricsCoords : Point) : void
		{
			_cartesianCoords = IsometricFunction.isometricToCartesian(isometricsCoords);
			x = _cartesianCoords.x;
			y = _cartesianCoords.y;
		}
		
		public function addTexture(textureID : int = 0) : void
		{
			if(textureID)
			{
				var vars:ImageLoaderVars = new ImageLoaderVars();
				vars.container(this);
				vars.onComplete(function():void
				{
					_imageLoader.content.x = -((_imageLoader.content.width) >> 1) >> 0;
					_imageLoader.content.y = -((_imageLoader.content.height) >> 2) >> 0;
				});
				
				var imageURL:String = 'textures/' + textureID.toString() + '.png';
				
				_imageLoader = new ImageLoader(imageURL, vars);
				_imageLoader.load(true);
			}
			else
			{
				if(_showPointer) drawPointer();
			}
		}
		
		private function drawPointer():void
		{
			if(_showPointer)
			{
				if(_pointer)
				{
					_pointer.graphics.clear();
				}
				else
				{
					_pointer = new Shape();
					addChild(_pointer);
				}
				
				if(_isMouseOver){_pointer.graphics.lineStyle(1, 0xCCCCCC);}else{_pointer.graphics.lineStyle(1, 0xEEEEEE);}
				if(_isSelected)
				{
					_pointer.graphics.lineStyle(1, 0x20FE20);
					_pointer.graphics.beginFill(0x80FE80);
				}else{_pointer.graphics.beginFill(0xFEFEFE);}
				_pointer.graphics.moveTo(0, -(IsometricFunction.entitySize >> 2));
				_pointer.graphics.lineTo((IsometricFunction.entitySize >> 1), 0);
				_pointer.graphics.lineTo(0, (IsometricFunction.entitySize >> 2));
				_pointer.graphics.lineTo(-(IsometricFunction.entitySize >> 1), 0);
				_pointer.graphics.lineTo(0, -(IsometricFunction.entitySize >> 2));
				_pointer.graphics.endFill();
				
				if(numChildren) setChildIndex(_pointer, numChildren - 1);
			}
			else
			{
				if(_pointer)
				{
					removeChild(_pointer);
					_pointer = null;
				}
			}
		}
		
		private function onMouseDownHandler(event:MouseEvent):void
		{

		}
		
		private function onMouseUpHandler(event:MouseEvent):void
		{
			
		}
		
		private function onMouseOverHandler(event:MouseEvent):void
		{
			isMouseOver = true;
		}
		
		private function onMouseOutHandler(event:MouseEvent):void
		{
			isMouseOver = false;
		}

		private function setIsometricCoordsTF():void
		{
			if(_showIsometricCoords)
			{
				if(_isometricCoordsTF) removeChild(_isometricCoordsTF);
				
				_isometricCoordsTF = new TextField();
				_isometricCoordsTF.text = isometricsCoords.x + 'x' + isometricsCoords.y;
				addChild(_isometricCoordsTF);
			}
		}

		public function get isometricsCoords():Point
		{
			return _isometricCoords;
		}

		public function set isometricsCoords(value:Point):void
		{
			_isometricCoords = value;
			name = _isometricCoords.x + 'x' + _isometricCoords.y;
			setPosition(_isometricCoords);
			setIsometricCoordsTF();
		}

		public function get isMouseOver():Boolean
		{
			return _isMouseOver;
		}

		public function set isMouseOver(value:Boolean):void
		{
			_isMouseOver = value;
			drawPointer();
			
			/*TweenMax.killChildTweensOf(this);
			if(_isMouseOver)
			{
				TweenMax.to(_instance, .3, { y : _cartesianCoords.y - 1 });
			}
			else
			{
				TweenMax.to(_instance, .3, { y : _cartesianCoords.y });
			}*/
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
			drawPointer();
		}


	}
}
