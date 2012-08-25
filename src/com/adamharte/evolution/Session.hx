package com.adamharte.evolution;
import awe6.core.ASession;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Session extends ASession
{
	public var name:String;
	public var highScore:Int;
	public var isWin:Bool; // temporary
	public var currentLevel:Int;
	
	override private function _init()
	{
		_version = 1; // incremement this every time you make a structural change to the session (it will force a reset on all users' systems)
		super._init();
	}
	
	override private function _getter():Void
	{
		super._getter();
		name = _data.name;
		highScore = _data.highScore;
		//currentLevel = _data.currentLevel;
	}
	
	override private function _setter():Void
	{
		super._setter();
		_data.name = name;
		_data.highScore = highScore;
		//_data.currentLevel = currentLevel;
	}
	
	override private function _resetter():Void
	{
		super._resetter();
		name = "???";
		highScore = 0;
		currentLevel = 0;
	}
	
	override public function getPercentageComplete():Float
	{
		return _tools.limit( Std.int( 100 * highScore / 1000 ), 0, 100 );
	}	
	
}