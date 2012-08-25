package com.adamharte.evolution.scenes;
import awe6.extras.gui.Text;
import awe6.interfaces.EKey;
import awe6.interfaces.ETextStyle;
import com.adamharte.evolution.gui.Button;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Intro extends AScene
{
	
	override private function _init():Void 
	{
		super._init();
		_kernel.session = _kernel.factory.createSession( "Basic" );
		
		_kernel.audio.isMute = true;
		
		var l_result:Text = new Text( _kernel, _kernel.factory.width, 50, _kernel.getConfig( "gui.scenes.intro.instructions" ), _kernel.factory.createTextStyle( ETextStyle.SUBHEAD ) );
		l_result.y = 70;
		addEntity( l_result, true, 2 );
		
		var l_button:Button = new Button( _kernel, _kernel.factory.keyNext, 0, 0, _kernel.scenes.next, null, null, _kernel.getConfig( "gui.buttons.start" ) );
		l_button.setPosition( ( _kernel.factory.width - l_button.width ) / 2, ( _kernel.factory.height - l_button.height ) / 2 );
		addEntity( l_button, true, 1 );
	}
	
	override private function _updater( ?p_deltaTime:Int = 0 ):Void
	{
		super._updater( p_deltaTime );
		if ( _kernel.inputs.keyboard.getIsKeyRelease( EKey.F ) )
		{
			_kernel.isFullScreen = !_kernel.isFullScreen;
		}
	}
}