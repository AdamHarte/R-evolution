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
import com.adamharte.evolution.actors.ParallaxBackground;
import com.adamharte.evolution.AssetManager;
import com.adamharte.evolution.Factory;
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
	private var bg1:ParallaxBackground;
	private var bg2:ParallaxBackground;
	private var bg3:ParallaxBackground;
	private var bg4:ParallaxBackground;
	
	
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
		
		
		bg4 = new ParallaxBackground(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND_4), 0.3);
		addEntity(bg4, true, 1);
		bg3 = new ParallaxBackground(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND_3), 0.35);
		addEntity(bg3, true, 1);
		bg2 = new ParallaxBackground(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND_2), 0.4);
		addEntity(bg2, true, 1);
		bg1 = new ParallaxBackground(_kernel, _assetManager.getViewAsset(EAsset.BACKGROUND_1), 0.6);
		addEntity(bg1, true, 1);
		
		
		//var clouds:Clouds = new Clouds(_kernel);
		//addEntity(clouds, true, 1);
		
		level = new Level(_kernel, _assetManager.getLevelData(_session.currentLevel));
		addEntity(level, true, 2);
		
		if (_session.attemptNumber == 0) 
		{
			// Show level name.
			var levelLabel:LevelLabel = new LevelLabel(_kernel);
			addEntity(levelLabel, true, 3);
		}
		
		//var levelLabelCorner:LevelLabel = new LevelLabel(_kernel, false);
		//addEntity(levelLabelCorner, true, 3);
		var message:String = 'Level: ' + Std.string(_session.currentLevel + 1);
		var label:Text = new Text( _kernel, 120, 50, message, _kernel.factory.createTextStyle( ETextStyle.SUBHEAD ) );
		label.y = _kernel.factory.height - 30;
		addEntity( label, true, 4 );
		
		_kernel.audio.start( "StartLevel", EAudioChannel.EFFECTS, 1, 0, .6 );
	}
	
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		
		bg1.updatePosition(level.x - 300, level.y);
		bg2.updatePosition(level.x - 300, level.y);
		bg3.updatePosition(level.x - 300, level.y);
		bg4.updatePosition(level.x - 300, level.y);
		
		if (_session.isWin) 
		{
			_kernel.audio.start( "Win", EAudioChannel.EFFECTS, 1, 0, .2 );
			
			_session.currentLevel++;
			_session.attemptNumber = 0;
			cast(_kernel.factory, Factory).kongApi.stats.submit('BeatLevel', _session.currentLevel);
			if (_session.currentLevel >= _session.totalLevels) 
			{
				//finished game.
				cast(_kernel.factory, Factory).kongApi.stats.submit('BeatFinalLevel', _session.currentLevel);
				_kernel.scenes.next();
			}
			else 
			{
				_kernel.scenes.restart();
			}
		}
		else if (level.isOutOfBounds) 
		{
			cast(_kernel.factory, Factory).kongApi.stats.submit('Deaths', 1);
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