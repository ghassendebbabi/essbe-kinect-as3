package fr.essbe.kinect.collection 
{
	/**
	 * ...
	 * @author ...
	 */
	public class KinectStack
	{
		private var __stack:Vector.<KinectTask>;
		private var __max:int;
		
		
		
		public function KinectStack() 
		{
			__stack = new Vector.<KinectTask>();
		}
		
		public function add(task:KinectTask):void 
		{
			__stack.push(task);
			task.id = __stack.length;
		}
		
		public function getNext():KinectTask
		{
			for each(var task:KinectTask in __stack)
			{
				if (!task.sent) return task;
			}
			
			return null;
		}
		
		public function remove(task:KinectTask):void 
		{
			__stack.splice(__stack.indexOf(task), 1);
		}
		
		public function getTasks():Vector.<KinectTask> 
		{
			return __stack;
		}
		
	}

}