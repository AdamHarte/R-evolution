package com.adamharte.evolution.actors;
import awe6.core.View;
import awe6.interfaces.IKernel;
import awe6.interfaces.EJoypadButton;
import com.adamharte.evolution.AssetManager;
import haxe.xml.Fast;
import com.adamharte.evolution.actors.Wheel;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Level extends PositionableEntity
{
	private var _assetsManager:AssetManager;
	private var _levelXml:Xml;
	private var _wheels:Array<Wheel>;
	private var _dude:Dude;
	
	public function new(p_kernel:IKernel, p_levelXml:Xml) 
	{
		_assetsManager = cast p_kernel.assets;
		_levelXml = p_levelXml;
		
		super(p_kernel, new View(p_kernel));
	}
	
	override private function _init():Void 
	{
		super._init();
		
		// Generate level from level xml data.
		_wheels = new Array<Wheel>();
		var levelData:Fast = new Fast(_levelXml);
		var bodiesData = levelData.node.bodies;
		for (body in bodiesData.nodes.body) 
		{
			var wheelX:Float = Std.parseFloat(body.att.x);
			var wheelY:Float = Std.parseFloat(body.att.y);
			var radius:Float = Std.parseFloat(body.att.size);
			var rotationSpeed:Float = Std.parseFloat(body.att.speed);
			var wheelType:EWheelType = getWheelType( Std.parseInt(body.att.type) );
			var wheel:Wheel = new Wheel(_kernel, radius, rotationSpeed, wheelType);
			wheel.setPosition(wheelX, wheelY);
			_wheels.push(wheel);
			addEntity(wheel, true, 1);
		}
		
		var player = levelData.node.player;
		var playerStartX:Float = Std.parseFloat(player.att.start_x);
		var playerStartY:Float = Std.parseFloat(player.att.start_y);
		_dude = new Dude(_kernel);
		_dude.setPosition(playerStartX, playerStartY);
		addEntity(_dude, true, 3);
		
		setPosition(0, 0);
	}
		
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		
		// Test for player/wheel collisions.
		for (wheel in _wheels) 
		{
			var dx:Float = wheel.x - _dude.x;
			var dy:Float = wheel.y - _dude.y;
			var dist:Float = dx*dx + dy*dy;
			var maxDist:Float = (wheel.radius + _dude.radius) * (wheel.radius + _dude.radius);
			
			if (dist < maxDist) 
			{
				wheel.isTouching = true;
				_dude.attachToWheel(wheel);
				
				break;
			}
			else 
			{
				wheel.isTouching = false;
				//_dude.attachToWheel(null);
			}
			
		}
		
		// Centre camera on player.
		var targetX:Float = (_kernel.factory.width * 0.5) - _dude.x;
		var targetY:Float = (_kernel.factory.height * 0.5) - _dude.y;
		var followSpeed:Float = 0.08;
		var cameraX:Float = x + ((targetX - x) * followSpeed);
		var cameraY:Float = y + ((targetY - y) * followSpeed);
		setPosition(cameraX, cameraY);
		//setPosition(targetX, targetY);
		
	}
	
	
	
	private function getWheelType(typeIndex:Int):EWheelType 
	{
		var wheelType:EWheelType = null;
		switch (typeIndex) 
		{
			case 1 : wheelType = EWheelType.STONE;
			case 2 : wheelType = EWheelType.WOOD;
			case 3 : wheelType = EWheelType.WAGON;
		}
		return wheelType;
	}
	
}