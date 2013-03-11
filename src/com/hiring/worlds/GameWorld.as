package com.hiring.worlds
{
	import adobe.utils.CustomActions;
	
	import com.hiring.Assets;
	import com.hiring.Global;
	import com.hiring.entities.HUD;
	import com.hiring.entities.Level;
	import com.hiring.entities.PlantLife;
	import com.hiring.entities.Player;
	
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	public class GameWorld extends World 
	{
		private var tileset_:Tilemap;
		private var loadedDoor_:Boolean = false;
		
		
		public function GameWorld() 
		{
			// Global.player = new Player(100, 100);
		}
		
		
		override public function begin():void 
		{	
			loadWorld();
		}
		
		
		private function loadWorld():void
		{
			removeAll();
			loadedDoor_ = false;
			
			// add(Global.player);
			
			add(new Entity(0, 0, tileset_ = new Tilemap(Assets.TILESET_WORLD, 
				FP.width, FP.height, 32, 32)));
			
			var doorIndex:int = 0;
			var placeDoor:int = FP.rand(62); // 62 spots the door can go
			var xCols:int = 20; //640 / 32
			var yCols:int = 15; //640 / 32
			for (var i:int = 0; i < xCols; i++)
			{
				for (var j:int = 0; j < yCols; j++)
				{		
					var randTile:int = FP.rand(4);
					var tileX:int = 32 * randTile;
					
					tileset_.setTile(i, j, randTile);
					
					if (i == 0 || j == 0 || i == 19 || j == 14)
					{
						if (!loadedDoor_)
						{
							// There are 62 valid spots an open door spot can be placed
							if ((i == 0 && j == 0) || (i == 19 && j == 0) || (i == 0 && j == 14) || (i == 19 && j == 14))
							{
								FP.world.add(new PlantLife(i * 32, j * 32, 0));
							}
							else
							{	
								if (placeDoor == doorIndex)
								{
									loadedDoor_ = true;
									continue;
								}
								else
								{
									FP.world.add(new PlantLife(i * 32, j *32, 0));
									doorIndex++;
								}
							}
						}
						else
						{
							FP.world.add(new PlantLife(i * 32, j *32, 0));
						}
					}
				}
			}
			
			Global.hud = new HUD();
			FP.world.add(Global.hud);
		}
		
		
		override public function update():void
		{
			if (Input.check(Global.keyEnter))
			{
				this.loadWorld();
			}
		}
	}
}