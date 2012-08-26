package com.adamharte.evolution.actors;
import awe6.core.drivers.AView;
import awe6.core.View;
import awe6.interfaces.IKernel;
import awe6.interfaces.IView;
import com.adamharte.evolution.AssetManager;
import com.adamharte.evolution.Session;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class ParallaxBackground extends PositionableEntity
{
	private var _session:Session;
	private var _assetsManager:AssetManager;
	private var _image:AView;
	private var _distance:Float;
	
	
	public function new(p_kernel:IKernel, p_img:IView, p_distance:Float) 
	{
		_assetsManager = cast p_kernel.assets;
		_session = cast p_kernel.session;
		_image = cast( p_img, AView);
		_distance = p_distance;
		
		super(p_kernel, new View(p_kernel));
	}
	
	override private function _init() : Void 
	{
		super._init();
		view.addChild(_image);
		//_images[1].x = _width;
		//_images[0].y = _images[1].y = _kernel.factory.height - _height;
	}
		
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		/*for (l_image in _images) 
		{
			l_image.x -= _speed * ( p_deltaTime * .001 ); // keeps _speed constant
			if ( l_image.x <= -_width) {
				var l_offset =  l_image.x + _width;
				l_image.x = _width + l_offset;
			}
		}*/
		
		
		
	}
	
	
	
	public function updatePosition(fullX:Float, fullY:Float):Void 
	{
		_image.x = fullX * _distance;
		//_image.y = fullY * (_distance * 0.1);
		
	}
	
}