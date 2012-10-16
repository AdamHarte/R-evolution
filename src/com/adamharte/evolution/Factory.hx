package com.adamharte.evolution;
import awe6.core.AFactory;
import awe6.core.Overlay;
import awe6.core.TextStyle;
import awe6.interfaces.EOverlayButton;
import awe6.interfaces.EScene;
import awe6.interfaces.ETextAlign;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IAssetManagerProcess;
import awe6.interfaces.IOverlayProcess;
import awe6.interfaces.IPreloader;
import awe6.interfaces.IScene;
import awe6.interfaces.ISession;
import awe6.interfaces.ITextStyle;
import awe6.interfaces.EKey;
import com.adamharte.evolution.scenes.Game;
import com.adamharte.evolution.scenes.Intro;
import com.adamharte.evolution.scenes.Results;
#if flash
import kong.KongregateApi;
#end

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Factory extends AFactory
{
	public var kongApi:KongregateApi;
	
	private var _assetManager:AssetManager;
	
	
	override private function _configurer( ?p_isPreconfig:Bool = false ):Void
	{
		id = "evolution";
		version = "0.1.001"; // major.minor.revision ... I recommend you use your SVN revision # for revision version, and automatically insert it into this file :-)
		author = "Adam Harte (adam@adamharte.com)";
		isDecached = true;
		width = 800;
		height = 480;
		bgColor = 0x000000;
		startingSceneType = EScene.INTRO;
		targetFramerate = 60;
		isFixedUpdates = false;
		
		keyPause = EKey.ESCAPE;
		keyBack = EKey.BACKSPACE;
	}
	
	override public function createAssetManager():IAssetManagerProcess
	{
		if ( _assetManager == null )
		{
			_assetManager = new AssetManager( _kernel );
		}
		return _assetManager;
	}
	
	override public function createOverlay():IOverlayProcess
	{
		var l_width:Int = 30;
		var l_overlay:Overlay = new Overlay( _kernel, l_width, l_width, _assetManager.overlayBackground, _assetManager.backUp, _assetManager.backOver, _assetManager.muteUp, _assetManager.muteOver, _assetManager.unmuteUp, _assetManager.unmuteOver, _assetManager.pauseUp, _assetManager.pauseOver, _assetManager.unpauseUp, _assetManager.unpauseOver );
		var l_x:Int = width - 10 - ( 3 * l_width );
		var l_y:Int = height - l_width;
		l_overlay.positionButton( EOverlayButton.BACK, l_x, l_y );
		l_overlay.positionButton( EOverlayButton.PAUSE, l_x += l_width, l_y );
		l_overlay.positionButton( EOverlayButton.UNPAUSE, l_x, l_y );
		l_overlay.positionButton( EOverlayButton.MUTE, l_x += l_width, l_y );
		l_overlay.positionButton( EOverlayButton.UNMUTE, l_x, l_y );
		return l_overlay;
	}
	
	override public function createPreloader():IPreloader
	{
		return new Preloader( _kernel, _getAssetUrls(), isDecached );
	}
	
	override public function createSession( ?p_id:String ):ISession
	{		
		return new Session( _kernel, p_id );
	}
	
	override public function createScene( p_type:EScene ):IScene
	{
		switch ( p_type )
		{
			case EScene.INTRO :
				return new Intro( _kernel, p_type );
			case EScene.GAME :
				return new Game( _kernel, p_type );
			case EScene.RESULTS :
				return new Results( _kernel, p_type );
			default :
				null;
		}
		return super.createScene( p_type );
	}	
	
	override public function createTextStyle( ?p_type:ETextStyle ):ITextStyle
	{
		if ( p_type == null )
		{
			p_type = ETextStyle.BODY;
		}
		var l_fontName:String = _assetManager.font.fontName;
		var l_result:TextStyle = new TextStyle( l_fontName, 12, 0xFFFFFF, false, false, ETextAlign.CENTER, 0, 0, 0, [ new flash.filters.GlowFilter( 0x020382, 1, 4, 4, 5, 2 ) ] );
		l_result.size = switch ( p_type )
		{
			case ETextStyle.HEADLINE :
				24;
			case ETextStyle.OVERSIZED :
				72;
			case ETextStyle.SUBHEAD :
				18;
			case ETextStyle.BUTTON :
				12;
			case ETextStyle.SMALLPRINT :
				6;
			default :
				12;
		}
		return l_result;
	}
	
	override public function getBackSceneType( p_type:EScene ):EScene
	{
		switch ( p_type )
		{
			case INTRO :
				return null;
			case GAME :
				return EScene.INTRO;
			case RESULTS :
				return EScene.INTRO;
			default :
				null;
		}
		return super.getBackSceneType( p_type );
	}	
	
	override public function getNextSceneType( p_type:EScene ):EScene
	{
		switch ( p_type )
		{
			case INTRO :
				return EScene.GAME;
			case GAME :
				return EScene.RESULTS;
			case RESULTS :
				return EScene.INTRO;
			default :
				null;
		}
		return super.getNextSceneType( p_type );
	}	
	
}