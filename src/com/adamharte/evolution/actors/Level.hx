package com.adamharte.evolution.actors;
import awe6.core.View;
import awe6.interfaces.IKernel;
import awe6.interfaces.EJoypadButton;
import com.adamharte.evolution.AssetManager;
import haxe.xml.Fast;

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
			var wheel:Wheel = new Wheel(_kernel, radius, rotationSpeed);
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
		
	}
		
	override private function _updater( ?p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		/*for (l_image in _images) 
		{
			l_image.x -= _speed * ( p_deltaTime * .001 ); // keeps _speed constant
			if ( l_image.x <= -_width) {
				var l_offset =  l_image.x + _width;
				l_image.x = _width + l_offset;
			}
		}*/
		
		
		//TODO: Test for player/wheel collisions.
		
		for (wheel in _wheels) 
		{
			var dx:Float = wheel.x - _dude.x;
			var dy:Float = wheel.y - _dude.y;
			var dist:Float = dx*dx + dy*dy;
			var maxDist:Float = (wheel.radius + _dude.radius) * (wheel.radius + _dude.radius);
			
			if (dist < maxDist) 
			{
				/*if (!wheel.isTouching) 
				{
					_dude.resetVelociyY();
				}*/
				wheel.isTouching = true;
				//var angleBetween:Float = Math.atan2(dy, dx);// * (180 / Math.PI);
				//_dude.setRotation(angleBetween * (180 / Math.PI) - 90);
				_dude.attachToWheel(wheel);
				
				//var moveDelta:Float = 0;
				
				// listen to virtual joypad
				/*if ( _kernel.inputs.joypad.getIsButtonDown( EJoypadButton.RIGHT ))
				{
					//_dx += _speed * l_adjustedDelta;
					moveDelta += _dude.runAcceleration;
				}
				if ( _kernel.inputs.joypad.getIsButtonDown( EJoypadButton.LEFT ))
				{
					//_dx -= _speed * l_adjustedDelta;
					moveDelta -= _dude.runAcceleration;
				}*/
				
				/*var maxDistSqrt:Float = Math.sqrt(maxDist);
				var op:Float = Math.sin(angleBetween + moveDelta + Math.PI) * maxDistSqrt;
				var ad:Float = Math.cos(angleBetween + moveDelta + Math.PI) * maxDistSqrt;
				_dude.setPosition(wheel.x + ad, wheel.y + op);*/
				
				/*if ( _kernel.inputs.joypad.getIsButtonDown( EJoypadButton.UP ))
				{
					//_dx += _speed * l_adjustedDelta;
					var jumpPower:Float = 9;
					_dude.setVelocity(Math.cos(angleBetween + Math.PI) * jumpPower, Math.sin(angleBetween + Math.PI) * jumpPower);
				}
				else 
				{
					_dude.resetVelociyY();
				}*/
				
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
		setPosition(targetX, targetY);
		
		
		
	}
	
}