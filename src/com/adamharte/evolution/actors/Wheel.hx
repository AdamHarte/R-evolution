package com.adamharte.evolution.actors;
import awe6.core.Context;
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
	public var wheelType(default, null):EWheelType;
	
	private var _assetManager:AssetManager;
	private var _sprite:Sprite;
	//private var _touchingSprite:Sprite;
	
	
	
	public function new(p_kernel:IKernel, p_radius:Float, p_rotationSpeed:Float, p_type:EWheelType) 
	{
		_assetManager = cast p_kernel.assets;
		isTouching = false;
		radius = p_radius;
		rotationSpeed = p_rotationSpeed;
		wheelType = p_type;
		
		super(p_kernel);
	}
	
	override private function _init():Void 
	{
		super._init();
		
		width = height = radius * 2;
		
		//_touchingSprite = new Sprite();
		//_touchingSprite.graphics.beginFill(0xFF0000, 0.8);
		//_touchingSprite.graphics.drawCircle(0, 0, radius);
		//_touchingSprite.visible = false;
		
		/*_sprite = new Sprite();
		_sprite.graphics.lineStyle(1, 0x009393, 0.8);
		_sprite.graphics.beginFill(0x00FF00, 0.6);
		_sprite.graphics.drawCircle(0, 0, radius);
		_sprite.graphics.endFill();
		_sprite.graphics.drawRect(radius * -0.6, radius * -0.6, radius * 1.2, radius * 1.2);
		_sprite.graphics.moveTo(0, -radius);
		_sprite.graphics.lineTo(0, radius);
		//_sprite.addChild(_touchingSprite);
		var wheelView:View = new View(_kernel, _sprite);*/
		
		var wheelView:AView = null;
		switch (wheelType) 
		{
			case EWheelType.GOLD  : wheelView = cast _assetManager.getViewAsset(EAsset.WHEEL_GOLD);
			case EWheelType.STONE : wheelView = cast _assetManager.getViewAsset(EAsset.WHEEL_STONE);
			case EWheelType.WOOD  : wheelView = cast _assetManager.getViewAsset(EAsset.WHEEL_WOOD);
			case EWheelType.WAGON : wheelView = cast _assetManager.getViewAsset(EAsset.WHEEL_WAGON);
		}
		
		// 0.06 // 0.94
		wheelView.context.width = wheelView.context.height = radius * 2.14;
		wheelView.context.x = wheelView.context.width * -0.5;
		wheelView.context.y = wheelView.context.height * -0.5;
		
		view.addChild(wheelView, 1);
		
		setAgenda(EAgenda.SUB_TYPE(_EWheelState.SPINNING));
	}
	
	override private function _updater(?p_deltaTime:Int = 0): Void
	{
		super._updater(p_deltaTime);
		var l_adjustedDelta:Float = p_deltaTime * .001;
		
		if (Type.enumEq(agenda, EAgenda.SUB_TYPE(_EWheelState.SPINNING))) 
		{
			//_sprite.rotation += ((180 / Math.PI) * rotationSpeed) * l_adjustedDelta;
			var context:Context = cast(view, AView).context;
			context.rotation += ((180 / Math.PI) * rotationSpeed) * l_adjustedDelta;
		}
		
		//_touchingSprite.visible = isTouching;
		
	}
	
}

private enum _EWheelState
{ 
	STOPPED;
	SPINNING;
}

enum EWheelType
{
	GOLD;
	STONE;
	WOOD;
	WAGON;
}
