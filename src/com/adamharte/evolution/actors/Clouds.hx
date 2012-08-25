package com.adamharte.evolution.actors;
import awe6.interfaces.IKernel;
import com.adamharte.evolution.AssetManager;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */

class Clouds extends ParallaxEntity
{
	public function new( p_kernel:IKernel) 
	{
		_assetsManager = cast p_kernel.assets;
		
		var l_speed = 100;
		
		var l_img1 = _assetsManager.getViewAsset(EAsset.CLOUDS);
		var l_img2 = _assetsManager.getViewAsset(EAsset.CLOUDS);
		
		super( p_kernel, l_img1, l_img2, l_speed);
	}
}