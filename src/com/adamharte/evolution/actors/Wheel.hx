package com.adamharte.evolution.actors;
import awe6.core.drivers.AView;
import awe6.core.View;
import awe6.interfaces.IKernel;
import awe6.interfaces.EAgenda;
import com.adamharte.evolution.AssetManager;
import nme.display.Sprite;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Wheel extends PositionableEntity
{
	public var radius(default, null):Float;
	public var rotationSpeed(default, null):Float;
	public var isTouching:Bool;
	
	private var _assetManager:AssetManager;
	private var _sprite:Sprite;
	private var _touchingSprite:Sprite;
	
	
	
	public function new(p_kernel:IKernel, p_radius:Float, p_rotationSpeed:Float) 
	{
		_assetManager = cast p_kernel.assets;
		isTouching = false;
		radius = p_radius;
		rotationSpeed = p_rotationSpeed;
		
		super(p_kernel);
	}
	
	override private function _init():Void 
	{
		super._init();
		
		width = height = radius * 2;
		
		_touchingSprite = new Sprite();
		_touchingSprite.graphics.beginFill(0xFF0000, 0.8);
		_touchingSprite.graphics.drawCircle(0, 0, radius);
		_touchingSprite.visible = false;
		
		_sprite = new Sprite();
		_sprite.graphics.lineStyle(1, 0x009393, 0.8);
		_sprite.graphics.beginFill(0x00FF00, 0.6);
		_sprite.graphics.drawCircle(0, 0, radius);
		_sprite.graphics.endFill();
		_sprite.graphics.drawRect(radius * -0.6, radius * -0.6, radius * 1.2, radius * 1.2);
		_sprite.graphics.moveTo(0, -radius);
		_sprite.graphics.lineTo(0, radius);
		_sprite.addChild(_touchingSprite);
		var wheelView:View = new View(_kernel, _sprite);
		
		view.addChild(wheelView, 1);
		
		setAgenda(EAgenda.SUB_TYPE(_EWheelState.SPINNING));
	}
	
	override private function _updater(?p_deltaTime:Int = 0): Void
	{
		super._updater(p_deltaTime);
		var l_adjustedDelta:Float = p_deltaTime * .001;
		
		if (Type.enumEq(agenda, EAgenda.SUB_TYPE(_EWheelState.SPINNING))) 
		{
			_sprite.rotation += ((180 / Math.PI) * rotationSpeed) * l_adjustedDelta;
		}
		
		_touchingSprite.visible = isTouching;
		
	}
	
}

private enum _EWheelState
{ 
	STOPPED;
	SPINNING;
}
