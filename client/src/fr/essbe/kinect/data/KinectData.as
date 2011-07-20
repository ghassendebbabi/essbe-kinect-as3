package fr.essbe.kinect.data 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class KinectData extends Object 
	{
		
		private var __first:int;
		private var __second:int;
		private var __buffer:ByteArray;
		
		public function KinectData() 
		{
			super();
		}
		
		public function get first():int 
		{
			return __first;
		}
		
		public function set first(value:int):void 
		{
			__first = value;
		}
		
		public function get second():int 
		{
			return __second;
		}
		
		public function set second(value:int):void 
		{
			__second = value;
		}
		
		public function get buffer():ByteArray 
		{
			return __buffer;
		}
		
		public function set buffer(value:ByteArray):void 
		{
			__buffer = value;
		}
		
	}

}