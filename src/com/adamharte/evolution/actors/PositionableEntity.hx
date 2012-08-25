package com.adamharte.evolution.actors;
import awe6.core.Context;
import awe6.core.drivers.AView;
import awe6.core.Entity;
import awe6.interfaces.IEntity;
import awe6.interfaces.IKernel;
import awe6.interfaces.IPositionable;
import awe6.interfaces.IView;

/**
 * ...
 * @author valerie.elimak - blog.elimak.com
 */

class PositionableEntity extends Entity, implements IPositionable
{
	public var x( default, _set_x )	:Float;
	public var y( default, _set_y )	:Float;
	public var width( _get_width, _set_width ):Float;
	public var height( _get_height, _set_height ):Float;
	
	public function new( p_kernel:IKernel, ?p_view: IView, ?p_id: String) 
	{
		var context = (p_view != null )? cast(p_view, AView).context : new Context();
		super( p_kernel, p_id, context );
	}
	
	override private function _init():Void 
	{
		super._init();
	}
	
	private function handleTest( msg: String, sender: IEntity ) : Bool
	{
		return true;
	}
	
	override private function _disposer():Void 
	{
		view.dispose();
		super._disposer();		
	}
	
	public function centreGraphics():Void 
	{
		var context:Context = cast(view, AView).context;
		context.x = context.width * -0.5;
		context.y = context.height * -0.5;
	}
	
	public function setPosition( p_x:Float, p_y:Float ):Void
	{
		x = p_x;
		y = p_y;
	}
	
	private function _set_x( p_value:Float ):Float
	{
		x = p_value;
		if ( view != null )
		{
			view.x = x;
		}
		return x;
	}
	
	private function _set_y( p_value:Float ):Float
	{
		y = p_value;
		if ( view != null )
		{
			view.y = y;
		}
		return y;
	}
	
	private function _set_width( p_value:Float ):Float
	{
		width = p_value;
		return width;
	}
	
	private function _set_height( p_value:Float ):Float
	{
		height = p_value;
		return height;
	}
	
	private function _get_width():Float
	{
		return width;
	}	
	
	private function _get_height():Float
	{
		return height;
	}
}
