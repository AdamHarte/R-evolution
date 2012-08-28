package com.adamharte.evolution;

import haxe.Log;
import haxe.PosInfos;
import haxe.Resource;
import kong.KongregateApi;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
#if flash
import org.flashdevelop.utils.FlashConnect;
import kong.Kongregate;
#end

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Main extends Sprite 
{
	#if debug
	private var isDebug:Bool = true;
	#else
	private var isDebug:Bool = false;
	#end
	
	public function new() 
	{
		super();
		
		if (stage != null) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(?e:Event = null):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		#if flash
		if (isDebug)
		{
			FlashConnect.redirect();
		}
		else 
		{
			Log.trace = function(v:Dynamic, ?infos:PosInfos):Void {};
		}
		
		Kongregate.loadApi(onKongLoad);
		#end
		
		
		
	}
	
	private function onKongLoad(api:KongregateApi) 
	{
		api.services.connect();
		
		var factory:Factory = new Factory(Lib.current, isDebug, Resource.getString('config'));
		factory.kongApi = api;
	}
	
	
	
	static public function main() 
	{
		Lib.current.addChild(new Main());
	}
}
