package com.adamharte.evolution.actors;
import awe6.core.Context;
import awe6.core.drivers.AView;
import awe6.interfaces.IKernel;
import awe6.interfaces.IView;
import awe6.interfaces.EAgenda;
import awe6.interfaces.EJoypadButton;
import awe6.interfaces.EAudioChannel;
import com.adamharte.evolution.AssetManager;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Dude extends PositionableEntity
{
	public var radius( default, null ):Float;
	//public var runAcceleration( default, null ):Float;
	
	private var _assetManager:AssetManager;
	private var _currentWheel:Wheel;
	private var _targetRotation:Float;
	private var _gravity:Float;
	private var _runSpeed:Float;
	private var _runSpeedMax:Float;
	private var _runAcceleration:Float;
	private var _runAccelerationBase:Float;
	private var _dx:Float;
	private var _dy:Float;
	private var _speed:Float;
	private var _friction:Float;
	private var _jumpFriction:Float;
	
	private var _dudeStand:PositionableEntity;
	private var _dudeRun:PositionableEntity;
	private var _dudeJump:PositionableEntity;
	private var _dudeSleep:PositionableEntity;
	
	
	public function new(p_kernel:IKernel) 
	{
		_assetManager = cast p_kernel.assets;
		
		super(p_kernel);
	}
	
	override private function _init():Void 
	{
		super._init();
		
		var dudeView:AView = cast _assetManager.getViewAsset(EAsset.DUDE_STAND);
		_dudeStand = new AnimatedEntity(_kernel, dudeView, _assetManager.getAnimationFrames(EAsset.DUDE_STAND));
		_dudeStand.centreGraphics();
		_dudeRun = new AnimatedEntity(_kernel, _assetManager.getViewAsset(EAsset.DUDE_RUN), _assetManager.getAnimationFrames(EAsset.DUDE_RUN));
		_dudeRun.centreGraphics();
		_dudeJump = new AnimatedEntity(_kernel, _assetManager.getViewAsset(EAsset.DUDE_JUMP), _assetManager.getAnimationFrames(EAsset.DUDE_JUMP));
		_dudeJump.centreGraphics();
		_dudeSleep = new AnimatedEntity(_kernel, _assetManager.getViewAsset(EAsset.DUDE_SLEEP), _assetManager.getAnimationFrames(EAsset.DUDE_SLEEP));
		_dudeSleep.centreGraphics();
		
		width = dudeView.context.width;
		height = dudeView.context.height;
		//dudeView.context.x = width * -0.5;
		//dudeView.context.y = height * -0.5;
		radius = 18; // height * 0.5;
		
		addEntity(_dudeStand, EAgenda.SUB_TYPE(_EDudeState.STAND), true, 1);
		addEntity(_dudeRun, EAgenda.SUB_TYPE(_EDudeState.RUN), true, 1);
		addEntity(_dudeJump , EAgenda.SUB_TYPE(_EDudeState.JUMP), true, 1);
		addEntity(_dudeSleep , EAgenda.SUB_TYPE(_EDudeState.SLEEP), true, 1);
		
		_targetRotation = 0;
		_runAccelerationBase = Math.PI * 0.03;
		_runAcceleration = _runAccelerationBase;
		_runSpeed = 0;
		_runSpeedMax = Math.PI * 1.5;
		_gravity = 0.22;
		_dx = _dy = 0;
		_speed = 50;
		_friction = 0.04;
		_jumpFriction = 0.02;
		
		setAgenda(EAgenda.SUB_TYPE(_EDudeState.STAND));
	}
	
	
	
	public function attachToWheel(wheel:Wheel):Void 
	{
		_currentWheel = wheel;
		
	}
	
	public function setRotation(angle:Float):Void 
	{
		//cast(view, AView).context.rotation = angle;
		_targetRotation = angle;
	}
	
	public function setVelocity(velocityX:Float, velocityY:Float):Void 
	{
		_dx = velocityX;
		_dy = velocityY;
	}
	
	public function resetVelociyY():Void 
	{
		_dy = 0;
	}
	
	
	
	override private function _updater(?p_deltaTime:Int = 0): Void
	{
		super._updater(p_deltaTime);
		var l_adjustedDelta:Float = p_deltaTime * .001;
		
		
		var rotationSpeed:Float = 0.6;
		
		
		if (_currentWheel != null) 
		{
			var dx:Float = _currentWheel.x - x;
			var dy:Float = _currentWheel.y - y;
			var dist:Float = dx*dx + dy*dy;
			var maxDist:Float = (_currentWheel.radius + radius) * (_currentWheel.radius + radius);
			
			var angleBetween:Float = Math.atan2(dy, dx);
			
			//cast(view, AView).context.rotation = angleBetween * (180 / Math.PI) - 90;
			setRotation(angleBetween * (180 / Math.PI) - 90);
			
			//var moveDelta:Float = 0;
			var distOffset:Float = 0;
			
			//TODO: Run acceleration is an angle, but it should be based on the current wheels radius.
			var ratio:Float = 100 / _currentWheel.radius;
			_runAcceleration = _runAccelerationBase * ratio;
			
			
			// listen to virtual joypad
			if ( _kernel.inputs.joypad.getIsButtonDown( EJoypadButton.RIGHT ))
			{
				_runSpeed += _runAcceleration * l_adjustedDelta;
				setAgenda(EAgenda.SUB_TYPE(_EDudeState.RUN));
				cast(view, AView).context.scaleX = 1;
			}
			if ( _kernel.inputs.joypad.getIsButtonDown( EJoypadButton.LEFT ))
			{
				_runSpeed -= _runAcceleration * l_adjustedDelta;
				setAgenda(EAgenda.SUB_TYPE(_EDudeState.RUN));
				cast(view, AView).context.scaleX = -1;
			}
			
			_runSpeed *= 1 - ( _friction * ( 1 - l_adjustedDelta ) );
			
			if ( _kernel.inputs.joypad.getIsButtonDown( EJoypadButton.UP ) )
			{
				var jumpPower:Float = 9;
				var moveOffset:Float = _runSpeed * 15; // Takes the run speed into account for the jump angle.
				_dx = Math.cos(angleBetween + Math.PI + moveOffset) * jumpPower;
				_dy = Math.sin(angleBetween + Math.PI + moveOffset) * jumpPower;
				distOffset = 6;
				_runSpeed *= 0.2;
				
				_kernel.audio.start( "Jump", EAudioChannel.EFFECTS, 1, 0, .8 );
				
				setAgenda(EAgenda.SUB_TYPE(_EDudeState.JUMP));
			}
			else 
			{
				resetVelociyY();
				
				/*if (y > _currentWheel.y + (_currentWheel.radius * 0.3)) 
				{
					distOffset = 20;
				}*/
				
				if (Math.abs(_runSpeed) < 0.005) 
				{
					setAgenda(EAgenda.SUB_TYPE(_EDudeState.STAND));
				}
				else 
				{
					_kernel.audio.start( "Step", EAudioChannel.EFFECTS, 1, 0, .1, 0, true );
				}
			}
			
			/*var yOffset:Float = 1;
			if (_currentWheel.y + op > _currentWheel.y) 
			{
				yOffset = 10;
			}*/
			
			var maxDistSqrt:Float = Math.sqrt(maxDist) + distOffset;
			var wheelRotationSpeed:Float = _currentWheel.rotationSpeed * l_adjustedDelta;
			var angle:Float = angleBetween + _runSpeed + wheelRotationSpeed + Math.PI;
			var op:Float = Math.sin(angle) * maxDistSqrt;
			var ad:Float = Math.cos(angle) * maxDistSqrt;
			setPosition(_currentWheel.x + ad, _currentWheel.y + op + 1);
			
			/*if (y > _currentWheel.y + (_currentWheel.radius * 0.3)) 
			{
				_currentWheel = null;
			}*/
		}
		else 
		{
			_dy += _gravity;
			
			// inertial friction
			_dx *= 1 - ( _jumpFriction * ( 1 - l_adjustedDelta ) );
			//_dy *= 1 - ( _friction * ( 1 - l_adjustedDelta ) );
			
			// apply inertia
			x += _dx;
			y += _dy;
			
			_targetRotation = 0;
			rotationSpeed = 0.05;
		}
		
		
		
		
		// Ease to target rotation.
		var context:Context = cast(view, AView).context;
		var shortestAngle:Float = _targetRotation - context.rotation;
		if (shortestAngle > 180) shortestAngle -= 360;
		if (shortestAngle < -180) shortestAngle += 360;
		context.rotation += (_targetRotation - context.rotation) * rotationSpeed;
		
		
		
		// keep position within screen
		//x = _tools.limit( x, -width * .5, _kernel.factory.width -( width * .5 ));
		//y = _tools.limit( y, -height * .5, _kernel.factory.height -( height * .5));
		
		//trace(x +', '+ y);
		
		//if ( _dx > 12 ) setAgenda(EAgenda.SUB_TYPE(_EDudeState.RUN));
		//if ( _dx <= 12 && _dx >= -2 ) setAgenda(EAgenda.SUB_TYPE(_EDudeState.STAND));
		//if ( _dx < -2 ) setAgenda(EAgenda.SUB_TYPE(_EDudeState.SLEEP));
		
		_currentWheel = null;
	}
	
}

private enum _EDudeState
{ 
	STAND;
	RUN; 
	JUMP;
	SLEEP;
}
