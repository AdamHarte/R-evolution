package com.adamharte.evolution;
import awe6.core.AAssetManager;
import awe6.core.View;
import awe6.extras.gui.BitmapDataScale9;
import awe6.interfaces.IView;
import haxe.xml.Fast;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.text.Font;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class AssetManager extends AAssetManager
{
	public var overlayBackground( default, null ):IView;
	public var backUp( default, null ):IView;
	public var backOver( default, null ):IView;
	public var muteUp( default, null ):IView;
	public var muteOver( default, null ):IView;
	public var unmuteUp( default, null ):IView;
	public var unmuteOver( default, null ):IView;
	public var pauseUp( default, null ):IView;
	public var pauseOver( default, null ):IView;
	public var unpauseUp( default, null ):IView;
	public var unpauseOver( default, null ):IView;
	public var background( default, null ):IView;
	public var buttonUp( default, null ):BitmapData;
	public var buttonOver( default, null ):BitmapData;
	public var font( default, null ):Font;
	public var levelData( default, null ):Xml;
	
	
	override private function _init():Void
	{
		super._init();
		overlayBackground = _createView( OVERLAY_BACKGROUND );
		backUp = _createView( OVERLAY_BACK_UP );
		backOver = _createView( OVERLAY_BACK_OVER );
		muteUp = _createView( OVERLAY_MUTE_UP );
		muteOver = _createView( OVERLAY_MUTE_OVER );
		unmuteUp = _createView( OVERLAY_UNMUTE_UP );
		unmuteOver = _createView( OVERLAY_UNMUTE_OVER );
		pauseUp = _createView( OVERLAY_PAUSE_UP );
		pauseOver = _createView( OVERLAY_PAUSE_OVER );
		unpauseUp = _createView( OVERLAY_UNPAUSE_UP );
		unpauseOver = _createView( OVERLAY_UNPAUSE_OVER );
		background = _createView( BACKGROUND );
		buttonUp = Assets.getBitmapData( "assets/ButtonUp.png" );
		buttonOver = Assets.getBitmapData( "assets/ButtonOver.png" );
		font = Assets.getFont( "assets/fonts/orbitron.ttf" );
		levelData = Xml.parse(Assets.getText("assets/levels/levels.xml"));
		
	}
	
	
	
	override public function getAsset( p_id:String, ?p_packageId:String, ?p_args:Array<Dynamic> ):Dynamic
	{
		if ( p_packageId == null )
		{
			p_packageId = _kernel.getConfig( "settings.assets.packages.default" );
		}
		if ( p_packageId == null )
		{
			p_packageId = _PACKAGE_ID;
		}		
		if ( ( p_packageId == _kernel.getConfig( "settings.assets.packages.audio" ) ) || ( p_packageId == "assets.audio" ) )
		{
			var l_extension:String = ".wav";
			#if cpp
			l_extension = ".wav";// ".ogg"; // doesn't work on Macs?
			#elseif js
			l_extension = untyped jeash.media.Sound.jeashCanPlayType( "ogg" ) ? ".ogg" : ".mp3";
			#end
			p_id += l_extension;
		}
		if ( ( p_packageId.length > 0 ) && ( p_packageId.substr( -1, 1 ) != "." ) )
		{
			p_packageId += ".";
		}
		var l_assetName:String = StringTools.replace( p_packageId, ".", "/" ) + p_id;
		var l_result:Dynamic = Assets.getSound( l_assetName );
		if ( l_result != null )
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getBitmapData( l_assetName );
		if ( l_result != null )
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getFont( l_assetName );
		if ( l_result != null )
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getText( l_assetName );
		if ( l_result != null )
		{
			return l_result;
		}
		var l_result:Dynamic = Assets.getBytes( l_assetName );
		if ( l_result != null )
		{
			return l_result;
		}
		return super.getAsset( p_id, p_packageId, p_args );
	}
	
	public function getViewAsset ( p_id: EAsset ) : IView
	{
		return _createView(p_id);
	}
	
	public function getLevelData(p_levelIndex:Int):Xml 
	{
		var resultLevel:Xml = null;
		var levelData:Fast = new Fast(levelData.firstElement()).node.levels;
		
		for (level in levelData.nodes.level) 
		{
			if (level.has.id && Std.parseInt(level.att.id) == p_levelIndex) 
			{
				resultLevel = level.x;
			}
		}
		
		return resultLevel;
	}
	
	public function getLevelCount():Int 
	{
		var levelData:Fast = new Fast(levelData.firstElement()).node.levels;
		return Lambda.count(levelData.nodes.level);
	}
	
	public function getAnimationFrames(p_type:EAsset):Array<BitmapData> 
	{
		var frames:Array<BitmapData> = new Array<BitmapData>();
		
		var filePrefix:String = '';
		var fileSuffix:String = '.png';
		var frameCount:Int = 1;
		
		switch( p_type )
		{
			case DUDE_STAND : 
				filePrefix = "assets/character/dude-stand-";
			case DUDE_RUN 	: 
				filePrefix = "assets/character/dude-run-";
				frameCount = 4;
			case DUDE_JUMP 	: 
				filePrefix = "assets/character/dude-jump-";
			case DUDE_SLEEP : 
				filePrefix = "assets/character/dude-stand-";
			default : null;
		}
		
		for (i in 0...frameCount) 
		{
			var frameData:BitmapData = Assets.getBitmapData( filePrefix + i + fileSuffix );
			if (frameData == null) break;
			
			frames.push( frameData );
		}
		
		return frames;
	}
	
	
	
	private function _createView( p_type:EAsset ):IView
	{
		var l_sprite:Sprite = new Sprite();
		var l_bitmap:Bitmap = new Bitmap();
		l_sprite.addChild( l_bitmap );
		switch( p_type )
		{
			#if !js
			case OVERLAY_BACKGROUND 	: l_bitmap.bitmapData = new BitmapDataScale9( Assets.getBitmapData( "assets/overlay/OverlayBackground.png" ), 110, 20, 550, 350, _kernel.factory.width, _kernel.factory.height, true );
			#else
			case OVERLAY_BACKGROUND 	: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/OverlayBackground.png" );
			#end
			case OVERLAY_BACK_UP 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/BackUp.png" );
			case OVERLAY_BACK_OVER 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/BackOver.png" );
			case OVERLAY_MUTE_UP 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/MuteUp.png" );
			case OVERLAY_MUTE_OVER 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/MuteOver.png" );
			case OVERLAY_UNMUTE_UP 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnmuteUp.png" );
			case OVERLAY_UNMUTE_OVER 	: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnmuteOver.png" );
			case OVERLAY_PAUSE_UP 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/PauseUp.png" );
			case OVERLAY_PAUSE_OVER 	: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/PauseOver.png" );
			case OVERLAY_UNPAUSE_UP 	: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnpauseUp.png" );
			case OVERLAY_UNPAUSE_OVER 	: l_bitmap.bitmapData = Assets.getBitmapData( "assets/overlay/buttons/UnpauseOver.png" );
			case TITLE 					: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/title.png" );
			case CLICK_TO_PLAY_TEXT 	: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/click-to-play.png" );
			case CONTROLS 				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/controls.png" );
			case CREDITS 				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/credits.png" );
			
			case MENU_BACKGROUND 		: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/menu-background.png" );
			case BACKGROUND 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/background.png" );
			case BACKGROUND_1 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/background-01.png" );
			case BACKGROUND_2 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/background-02.png" );
			case BACKGROUND_3 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/background-03.png" );
			case BACKGROUND_4 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/background-04.png" );
			
			case CLOUDS 				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/scenes/clouds.png" );
			
			case DUDE_STAND 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/character/dude-stand-0.png" );
			case DUDE_RUN 				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/character/dude-run-0.png" );
			case DUDE_JUMP 				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/character/dude-jump-0.png" );
			case DUDE_SLEEP 			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/character/dude-stand-0.png" );
			
			case WHEEL_GOLD				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/levels/wheel-gold.png" );
			case WHEEL_STONE			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/levels/wheel-stone.png" );
			case WHEEL_WOOD				: l_bitmap.bitmapData = Assets.getBitmapData( "assets/levels/wheel-wood.png" );
			case WHEEL_WAGON			: l_bitmap.bitmapData = Assets.getBitmapData( "assets/levels/wheel-wagon.png" );
			
		}
		return new View( _kernel, l_sprite );
	}
	
}

enum EAsset
{
	OVERLAY_BACKGROUND;
	OVERLAY_BACK_UP;
	OVERLAY_BACK_OVER;
	OVERLAY_MUTE_UP;
	OVERLAY_MUTE_OVER;
	OVERLAY_UNMUTE_UP;
	OVERLAY_UNMUTE_OVER;
	OVERLAY_PAUSE_UP;
	OVERLAY_PAUSE_OVER;
	OVERLAY_UNPAUSE_UP;
	OVERLAY_UNPAUSE_OVER;
	TITLE;
	CLICK_TO_PLAY_TEXT;
	CONTROLS;
	CREDITS;
	
	MENU_BACKGROUND;
	BACKGROUND;
	BACKGROUND_1;
	BACKGROUND_2;
	BACKGROUND_3;
	BACKGROUND_4;
	
	CLOUDS;
	
	DUDE_STAND;
	DUDE_RUN;
	DUDE_JUMP;
	DUDE_SLEEP;
	
	WHEEL_GOLD;
	WHEEL_STONE;
	WHEEL_WOOD;
	WHEEL_WAGON;
}
