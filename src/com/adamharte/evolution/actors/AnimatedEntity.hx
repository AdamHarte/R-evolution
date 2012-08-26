package com.adamharte.evolution.actors;
import awe6.core.Context;
import awe6.core.drivers.AView;
import awe6.interfaces.IKernel;
import awe6.interfaces.IView;
import nme.display.Bitmap;
import nme.display.BitmapData;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class AnimatedEntity extends PositionableEntity
{
	private var _animationFrames:Array<BitmapData>;
	private var _currentAnimFrame:Int;
	private var _animFrameTimer:Float;
	
	public function new(p_kernel:IKernel, ?p_view: IView, ?p_animationFrames:Array<BitmapData>) 
	{
		_animationFrames = p_animationFrames;
		_currentAnimFrame = 0;
		_animFrameTimer = 0;
		super(p_kernel, p_view);
	}
	
	
	
	override private function _updater(?p_deltaTime:Int = 0): Void
	{
		super._updater(p_deltaTime);
		var l_adjustedDelta:Float = p_deltaTime * .001;
		
		//Go to next animation frame.
		var context:Context = cast(view, AView).context;
		//view.clear();
		//view.addChild();
		
		var bmp:Bitmap = getNextFrame();
		
		//context.removeChildren();
		while (context.numChildren > 0) 
		{
			context.removeChildAt(0);
		}
		context.addChild(bmp);
		
	}
	
	private function getNextFrame():Bitmap 
	{
		_animFrameTimer += 0.2;
		_currentAnimFrame = Std.int(_animFrameTimer);
		if (_currentAnimFrame >= _animationFrames.length) _animFrameTimer = _currentAnimFrame = 0;
		
		return new Bitmap(_animationFrames[_currentAnimFrame]);
	}
	
}