package com.adamharte.evolution;

import haxe.Log;
import haxe.PosInfos;
import haxe.Resource;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
#if flash
import org.flashdevelop.utils.FlashConnect;
#end

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Main extends Sprite 
{
	
	static public function main() 
	{
		#if debug
		var isDebug:Bool = true;
		#else
		var isDebug:Bool = false;
		#end
		#if flash
		if (isDebug)
		{
			FlashConnect.redirect();
		}
		else 
		{
			Log.trace = function(v:Dynamic, ?infos:PosInfos):Void {};
		}
		#end
		
		var factory:Factory = new Factory(Lib.current, isDebug, Resource.getString('config'));
	}
	
}
