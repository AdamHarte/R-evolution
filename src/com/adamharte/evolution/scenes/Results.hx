package com.adamharte.evolution.scenes;
import awe6.extras.gui.Text;
import awe6.interfaces.ETextStyle;
import com.adamharte.evolution.gui.Button;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Results extends AScene 
{
	
	override private function _init():Void 
	{
		super._init();	
		var l_button:Button = new Button( _kernel, _kernel.factory.keyNext, 0, 0, _kernel.scenes.next, null, null, _kernel.getConfig( "gui.buttons.next" ) );
		l_button.setPosition( ( _kernel.factory.width - l_button.width ) / 2, ( _kernel.factory.height - l_button.height ) / 2 );
		addEntity( l_button, true, 1 );
		
		var l_message:String = _kernel.getConfig( "gui.scenes.results." + ( _session.isWin ? "win" : "lose" ) ) + _tools.convertAgeToFormattedTime( ( 1000 * Game.TIME_LIMIT ) - _session.highScore );
		var l_result:Text = new Text( _kernel, _kernel.factory.width, 50, l_message, _kernel.factory.createTextStyle( ETextStyle.SUBHEAD ) );
		l_result.y = 70;
		addEntity( l_result, true, 2 );
		
	}
	
}