/**
* Copyright (c) 2011 EssBe
*  
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
* to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
* and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
* IN THE SOFTWARE.
*/

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