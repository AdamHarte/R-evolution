package com.adamharte.evolution.scenes;
import awe6.core.drivers.AView;
import awe6.core.Scene;
import awe6.extras.gui.Text;
import awe6.interfaces.EKey;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IKernel;
import awe6.interfaces.EScene;
import awe6.interfaces.EAudioChannel;
import awe6.interfaces.EMouseButton;
import com.adamharte.evolution.AssetManager;
import com.adamharte.evolution.gui.Button;
import com.adamharte.evolution.Session;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Intro extends Scene
{
	private var _session:Session;
	private var _assetManager:AssetManager;
	private var clickToBeginText:AView;
	private var _phase:Float;
	
	
	public function new( p_kernel:IKernel, p_type:EScene, ?p_isPauseable:Bool = false, ?p_isMutable:Bool = true, ?p_isSessionSavedOnNext:Bool = false ) 
	{
		_session = cast p_kernel.session;
		_assetManager = cast p_kernel.assets;
		
		super( p_kernel, p_type, p_isPauseable, p_isMutable, p_isSessionSavedOnNext );
	}
	
	override private function _init():Void 
	{
		super._init();
		_kernel.session = _kernel.factory.createSession( "Basic" );
		
		//_kernel.audio.isMute = true;
		
		view.addChild( _assetManager.background, 0 );
		
		var title:AView = cast _assetManager.getViewAsset(EAsset.TITLE);
		title.setPosition( ( _kernel.factory.width - title.context.width ) / 2, ( (_kernel.factory.height/ 2) - title.context.height ) / 2 );
		view.addChild( title, 1 );
		
		var controls:AView = cast _assetManager.getViewAsset(EAsset.CONTROLS);
		controls.setPosition( ( _kernel.factory.width - controls.context.width ) / 2, ( (_kernel.factory.height * 1.1) - controls.context.height ) / 2 );
		view.addChild( controls, 1 );
		
		var credits:AView = cast _assetManager.getViewAsset(EAsset.CREDITS);
		credits.setPosition( _kernel.factory.width * 0.02, (_kernel.factory.height * 0.98) - credits.context.height );
		view.addChild( credits, 1 );
		
		clickToBeginText = cast _assetManager.getViewAsset(EAsset.CLICK_TO_PLAY_TEXT);
		clickToBeginText.setPosition( ( _kernel.factory.width - clickToBeginText.context.width ) / 2, ( (_kernel.factory.height * 1.6) - clickToBeginText.context.height ) / 2 );
		view.addChild( clickToBeginText, 2 );
		_phase = 0;
		
		//_kernel.audio.start( "MusicMenu", EAudioChannel.MUSIC, -1, 0, .125, 0, true );
	}
	
	override private function _updater( ?p_deltaTime:Int = 0 ):Void
	{
		super._updater( p_deltaTime );
		if ( _kernel.inputs.keyboard.getIsKeyRelease( EKey.F ) )
		{
			_kernel.isFullScreen = !_kernel.isFullScreen;
		}
		if ( _kernel.inputs.mouse.getIsButtonPress( EMouseButton.LEFT ) || _kernel.inputs.keyboard.getIsKeyRelease( EKey.SPACE ) ) 
		{
			_kernel.scenes.next();
		}
		
		// Pulse text.
		_phase += p_deltaTime * 0.004;
		clickToBeginText.context.alpha = (Math.sin(_phase) * 0.3) + 0.7;
		
	}
}