package fr.essbe.kinect.data 
{
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class JointsData extends Vector3D 
	{
		private var __id:int;
		
		public function JointsData(ID:int,x:Number,y:Number,z:Number,w:Number) 
		{
			super(x, y, z, w);
			this.__id = ID;
		}
		
		public function get id():int 
		{
			return __id;
		}
		
		public function set id(value:int):void 
		{
			__id = value;
		}
		
	}

}