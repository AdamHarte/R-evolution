package com.adamharte.evolution.scenes;
import awe6.core.Scene;
import awe6.extras.gui.Text;
import awe6.interfaces.EAudioChannel;
import awe6.interfaces.EScene;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IKernel;
import com.adamharte.evolution.actors.Clouds;
import com.adamharte.evolution.actors.Dude;
import com.adamharte.evolution.actors.Level;
import com.adamharte.evolution.AssetManager;
import com.adamharte.evolution.Session;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Game extends Scene
{
	public static inline var TIME_LIMIT = 30; // Seconds.
	
	private var _session:Session;
	private var _assetManager:AssetManager;
	private var _timer:Text;
	private var _score:Int;
	
	
	public function new( p_kernel:IKernel, p_type:EScene ) 
	{
		_session = cast p_kernel.session;
		_assetManager = cast p_kernel.assets;
		super( p_kernel, p_type, true, true, true );
	}
	
	override private function _init():Void 
	{
		super._init();
		
		_session.isWin = false;
		
		view.addChild( _assetManager.background, 0 );
		
		_timer = new Text( _kernel, _kernel.factory.width, 50, Std.string( _tools.convertAgeToFormattedTime( 0 ) ), _kernel.factory.createTextStyle( ETextStyle.SUBHEAD ) );
		_timer.y = 70;
		addEntity( _timer, true, 1000 );
		
		_kernel.audio.stop( "MusicMenu", EAudioChannel.MUSIC );
		_kernel.audio.start( "MusicGame", EAudioChannel.MUSIC, -1, 0, .5, 0, true );
		
		/*for ( i in 0...10 )
		{
			addEntity( new Sphere( _kernel ), true, i + 10 );
		}*/
		
		var clouds:Clouds = new Clouds(_kernel);
		addEntity(clouds, true, 1);
		
		var level:Level = new Level(_kernel, _assetManager.getLevelData(_session.currentLevel));
		addEntity(level, true, 2);
		
		//var dude:Dude = new Dude(_kernel);
		//addEntity(dude, true, 3);
		
	}
	
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		
		_score = Std.int( _tools.limit( ( 1000 * TIME_LIMIT ) - _age, 0, _tools.BIG_NUMBER ) );
		if ( _score == 0 )
		{
			_gameOver();
		}
		_timer.text = _tools.convertAgeToFormattedTime( _age );
		
		/*var l_spheres:Array<Sphere> = getEntitiesByClass( Sphere );
		if ( ( l_spheres == null ) || ( l_spheres.length == 0 ) )
		{
			_gameOver();
		}*/
	}
	
	override private function _disposer():Void 
	{
		_kernel.audio.stop( "MusicGame", EAudioChannel.MUSIC );
		super._disposer();
	}	
	
	private function _gameOver():Void
	{
		if ( _score > _session.highScore )
		{
			_session.isWin = true;
			_session.highScore = _score;
		}
		_kernel.scenes.next();
	}
	
}