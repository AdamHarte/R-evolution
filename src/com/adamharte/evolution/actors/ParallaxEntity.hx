package com.adamharte.evolution.actors;
import awe6.core.drivers.AView;
import awe6.core.View;
import awe6.interfaces.IKernel;
import awe6.interfaces.IView;
import com.adamharte.evolution.AssetManager;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class ParallaxEntity extends PositionableEntity
{
	private var _assetsManager:AssetManager;
	private var _speed:Float;
	private var _images:Array<AView>;
	private var _width:Float;
	private var _height:Float;
		
	public function new( p_kernel:IKernel, p_img1:IView, p_img2:IView, p_speed:Float) 
	{
		_speed = p_speed;
		_images = [ cast( p_img1, AView), cast (p_img2, AView)];
		// saving the size of our images
		_width = _images[0].context.width;
		_height = _images[0].context.height;
		
		super(p_kernel, new View(p_kernel));
	}
	
	override private function _init() : Void 
	{
		super._init();
		view.addChild(_images[0]);
		view.addChild(_images[1]);
		_images[1].x = _width;
		_images[0].y = _images[1].y = _kernel.factory.height - _height;
	}
		
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		for (l_image in _images) 
		{
			l_image.x -= _speed * ( p_deltaTime * .001 ); // keeps _speed constant
			if ( l_image.x <= -_width) {
				var l_offset =  l_image.x + _width;
				l_image.x = _width + l_offset;
			}
		}
	}
}