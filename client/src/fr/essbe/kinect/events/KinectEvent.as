package fr.essbe.kinect.events 
{
	import flash.events.Event;
	import fr.essbe.kinect.data.KinectData;
	
	/**
	 * ...
	 * @author EssBe
	 */
	public class KinectEvent extends Event 
	{
		public static const ON_DEPTH:String = "onDepth";
		public static const ON_PLAYERS:String = "onPlayers";
		public static const ON_DEPTH_PLAYERS:String = "onDepthPlayers";
		public static const ON_RGB:String = "onRGB";
		public static const ON_SKELETON:String = "onSkeleton";
		
		private var __data:KinectData;
		
		public function KinectEvent(type:String, data:KinectData) 
		{
			super(type, false, false);
			__data = data;
			
		}
		
		public function get data():KinectData 
		{
			return __data;
		}
		
	}

}