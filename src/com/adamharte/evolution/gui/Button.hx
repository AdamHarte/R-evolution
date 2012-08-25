package com.adamharte.evolution.gui;
import awe6.core.BasicButton;
import awe6.core.Context;
import awe6.core.View;
import awe6.extras.gui.Text;
import awe6.interfaces.EAudioChannel;
import awe6.interfaces.EKey;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IKernel;
import awe6.interfaces.IView;
import com.adamharte.evolution.AssetManager;
import nme.display.Bitmap;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Button extends BasicButton
{
	public var label:String;
	
	private var _assetManager:AssetManager;
	private var _marginWidth:Int;
	private var _marginHeight:Int;
	private var _upView:IView;
	private var _overView:IView;
	private var _upContext:Context;
	private var _overContext:Context;
	
	
	public function new( p_kernel:IKernel, ?p_key:EKey, ?p_x:Float = 0, ?p_y:Float = 0, ?p_onClick:Void->Void, ?p_onRollOver:Void->Void, ?p_onRollOut:Void->Void, ?p_label:String ) 
	{
		_assetManager = cast p_kernel.assets;
		label = p_label;
		_upContext = new Context();
		_overContext = new Context();
		_upView = new View( p_kernel, _upContext );
		_overView = new View( p_kernel, _overContext );
		super( p_kernel, _upView, _overView, 160, 40, p_x, p_y, p_key, p_onClick, p_onRollOver, p_onRollOut );
	}
	
	override private function _init():Void
	{
		super._init();
		_marginWidth = 10;
		_marginHeight = 12;
		_upContext.addChild( _createButtonState( false ) );
		_overContext.addChild( _createButtonState( true ) );
	}
	
	private function _createButtonState( ?p_isOver:Bool = false ):Context
	{
		var l_result:Context = new Context();
		l_result.addChild( new Bitmap( p_isOver ? _assetManager.buttonOver : _assetManager.buttonUp ) );		
		var l_text:Text = new Text( _kernel, width - ( 2 * _marginWidth ), height - ( 2 * _marginHeight ), label, _kernel.factory.createTextStyle( ETextStyle.BUTTON ) );
		l_text.setPosition( _marginWidth, _marginHeight );
		l_result.addChild( untyped l_text._sprite ); // safe ancestry cast
		return l_result;
	}
	
	override public function onClick():Void
	{
		_kernel.audio.start( "ButtonDown", EAudioChannel.INTERFACE );
		super.onClick();
	}
	
	override public function onRollOver():Void
	{
		_kernel.audio.start( "ButtonOver", EAudioChannel.INTERFACE );
		super.onRollOver();
	}
	
}