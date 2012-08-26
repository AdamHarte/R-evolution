package com.adamharte.evolution.gui;
import awe6.core.drivers.AView;
import awe6.extras.gui.Text;
import awe6.interfaces.IKernel;
import awe6.interfaces.ETextStyle;
import com.adamharte.evolution.actors.PositionableEntity;
import com.adamharte.evolution.AssetManager;
import com.adamharte.evolution.Session;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class LevelLabel extends PositionableEntity
{
	private var _assetManager:AssetManager;
	private var _session:Session;
	
	
	public function new(p_kernel:IKernel) 
	{
		_assetManager = cast p_kernel.assets;
		_session = cast p_kernel.session;
		
		super(p_kernel);
	}
	
	override private function _init():Void 
	{
		super._init();
		
		
		var message:String = 'Level: ' + Std.string(_session.currentLevel + 1);
		var label:Text = new Text( _kernel, _kernel.factory.width, 50, message, _kernel.factory.createTextStyle( ETextStyle.SUBHEAD ) );
		label.y = 70;
		addEntity( label, true, 2 );
	}
	
	override private function _updater(?p_deltaTime:Int = 0): Void
	{
		super._updater(p_deltaTime);
		var l_adjustedDelta:Float = p_deltaTime * .001;
		
		if (_age < 2500) 
		{
			if (_age > 2000) 
			{
				cast(view, AView).context.alpha = 1.0 - ((_age - 2000) / 500);
			}
		}
		else 
		{
			cast(view, AView).context.alpha = 0;
		}
		
		
		
	}
	
}