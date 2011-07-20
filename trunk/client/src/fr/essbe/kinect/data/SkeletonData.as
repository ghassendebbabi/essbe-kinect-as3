package fr.essbe.kinect.data 
{
	import flash.display.JointStyle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author ...
	 */
	public class SkeletonData extends Object 
	{
		
		private var __joints:Vector.<JointsData>
		
		public function SkeletonData(data:ByteArray) 
		{
			super();
			
			__joints = new Vector.<JointsData>();
			data.endian = Endian.LITTLE_ENDIAN;
			data.position = 0;
			var __userID:int = data.readInt();
			__joints.push(new JointsData(JointID.HEAD, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.SHOULDER_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.SHOULDER_CENTER, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.SHOULDER_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.ELBOW_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.ELBOW_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.WRIST_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.WRIST_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.HAND_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.HAND_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.SPINE, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.HIP_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.HIP_CENTER, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.HIP_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.KNEE_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.KNEE_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.ANKLE_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.ANKLE_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.FOOT_LEFT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
			__joints.push(new JointsData(JointID.FOOT_RIGHT, data.readInt(), data.readInt(), data.readInt(), data.readInt()));
		}
		
		public function get joints():Vector.<JointsData> 
		{
			return __joints;
		}
		
		public function getJoint(jointID:int):JointsData
		{
			return __joints[jointID];
		}
		
	}

}