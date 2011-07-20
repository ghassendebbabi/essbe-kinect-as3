package fr.essbe.kinect.collection 
{
	/**
	 * ...
	 * @author ...
	 */
	public class KinectTask extends Object 
	{
		private var __id:int;
		private var __first:int;
		private var __second:int;
		private var __sent:Boolean;
		
		public function KinectTask(first:int, second:int) 
		{
			this.__first = first;
			this.__second = second;
			__sent = false;
		}
		
		public function get second():int 
		{
			return __second;
		}
		
		public function set second(value:int):void 
		{
			__second = value;
		}
		
		public function get first():int 
		{
			return __first;
		}
		
		public function set first(value:int):void 
		{
			__first = value;
		}
		
		public function get sent():Boolean 
		{
			return __sent;
		}
		
		public function set sent(value:Boolean):void 
		{
			__sent = value;
		}
		
		public function get id():int 
		{
			return __id;
		}
		
		public function set id(value:int):void 
		{
			__id = value;
		}
		
		public function reset():void 
		{
			__sent = false;
		}
		
	}

}