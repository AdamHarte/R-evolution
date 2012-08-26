package com.adamharte.evolution.scenes;
import awe6.core.Scene;
import awe6.extras.gui.Text;
import awe6.interfaces.EAudioChannel;
import awe6.interfaces.EScene;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IKernel;
import com.adamharte.evolution.AssetManager;
import com.adamharte.evolution.Session;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class AScene extends Scene
{
	private var _session:Session;
	private var _assetManager:AssetManager;
	private var _title:String;
	private var _titleText:Text;
	private var _isMusic:Bool;
	
	
	public function new( p_kernel:IKernel, p_type:EScene, ?p_isPauseable:Bool = false, ?p_isMutable:Bool = true, ?p_isSessionSavedOnNext:Bool = false ) 
	{
		_session = cast p_kernel.session;
		_assetManager = cast p_kernel.assets;
		_title = "?";
		super( p_kernel, p_type, p_isPauseable, p_isMutable, p_isSessionSavedOnNext );
	}
	
	override private function _init():Void 
	{
		super._init();
		view.addChild( _assetManager.getViewAsset(EAsset.MENU_BACKGROUND), 0 );
		
		var l_sceneType:String = _tools.toCamelCase( Std.string( type ) );
		_title = Std.string( _kernel.getConfig( "gui.scenes." + l_sceneType + ".title" ) );
		_titleText = new Text( _kernel, _kernel.factory.width, 50, _title, _kernel.factory.createTextStyle( ETextStyle.HEADLINE ) );
		_titleText.y = 40;
		addEntity( _titleText, true, 100 );
		
		//_kernel.audio.start( "MusicMenu", EAudioChannel.MUSIC, -1, 0, .125, 0, true );
	}
	
}