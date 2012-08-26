package com.adamharte.evolution.scenes;
import awe6.core.drivers.AView;
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
import com.adamharte.evolution.gui.LevelLabel;
import com.adamharte.evolution.Session;
import nme.ui.Mouse;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Game extends Scene
{
	private var _session:Session;
	private var _assetManager:AssetManager;
	//private var _score:Int;
	private var level:Level;
	
	
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
		_session.totalLevels = _assetManager.getLevelCount();
		
		//Mouse.hide();
		
		view.addChild( _assetManager.background, 0 );
		
		//_kernel.audio.stop( "MusicMenu", EAudioChannel.MUSIC );
		//_kernel.audio.start( "MusicGame", EAudioChannel.MUSIC, -1, 0, .5, 0, true );
		
		var clouds:Clouds = new Clouds(_kernel);
		addEntity(clouds, true, 1);
		
		level = new Level(_kernel, _assetManager.getLevelData(_session.currentLevel));
		addEntity(level, true, 2);
		
		if (_session.attemptNumber == 0) 
		{
			// Show level name.
			var levelLabel:LevelLabel = new LevelLabel(_kernel);
			addEntity(levelLabel, true, 3);
		}
		
		_kernel.audio.start( "StartLevel", EAudioChannel.EFFECTS, 1, 0, .6 );
	}
	
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		
		if (_session.isWin) 
		{
			_session.currentLevel++;
			_session.attemptNumber = 0;
			if (_session.currentLevel >= _session.totalLevels) 
			{
				//finished game.
				_kernel.scenes.next();
			}
			else 
			{
				_kernel.scenes.restart();
			}
		}
		else if (level.isOutOfBounds) 
		{
			_gameOver();
		}
	}
	
	override private function _disposer():Void 
	{
		_kernel.audio.stop( "MusicGame", EAudioChannel.MUSIC );
		super._disposer();
	}	
	
	private function _gameOver():Void
	{
		/*if ( _score > _session.highScore )
		{
			_session.isWin = true;
			_session.highScore = _score;
		}*/
		
		_session.attemptNumber++;
		
		_kernel.audio.start( "Die", EAudioChannel.EFFECTS, 1, 0, .8 );
		
		//_kernel.scenes.next();
		_kernel.scenes.restart();
	}
	
}