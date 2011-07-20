package fr.essbe.kinect.events 
{
	import flash.events.Event;
	import fr.essbe.kinect.data.KinectData;
	
	/**
	 * ...
	 * @author EssBe
	 */
	public class KinectSocketEvent extends Event 
	{
		static public const ONDATA:String = "onData";
		
		private var __data:KinectData;
		
		public function KinectSocketEvent(type:String, data:KinectData = null) 
		{
			super(type,false,false);
			__data = data;
			
		}
		
		public function get data():KinectData 
		{
			return __data;
		}
		
	}

}