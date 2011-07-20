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

package fr.essbe.kinect.display 
{
	import flash.display.Sprite;
	import fr.essbe.kinect.data.JointID;
	import fr.essbe.kinect.data.JointsData;
	import fr.essbe.kinect.data.SkeletonData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleSkeleton extends Sprite 
	{
		
		public function SimpleSkeleton(data:SkeletonData, context:Sprite) 
		{
			super();
			
			var color:uint = 0xff00ff;
			
			context.graphics.lineStyle(2, color);
			context.graphics.beginFill(color);
			
			__drawCircle(context, data.getJoint(JointID.HEAD), 20);
			__drawCircle(context, data.getJoint(JointID.SHOULDER_LEFT), 10);
			__drawCircle(context, data.getJoint(JointID.SHOULDER_RIGHT), 10);
			__drawCircle(context, data.getJoint(JointID.ELBOW_LEFT), 5);
			__drawCircle(context, data.getJoint(JointID.ELBOW_RIGHT), 5);
			__drawCircle(context, data.getJoint(JointID.HAND_LEFT), 10);
			__drawCircle(context, data.getJoint(JointID.HAND_RIGHT), 10);
			__drawCircle(context, data.getJoint(JointID.SPINE), 10);
			__drawCircle(context, data.getJoint(JointID.HIP_LEFT), 10);
			__drawCircle(context, data.getJoint(JointID.HIP_RIGHT), 10);
			__drawCircle(context, data.getJoint(JointID.KNEE_LEFT), 5);
			__drawCircle(context, data.getJoint(JointID.KNEE_RIGHT), 5);
			__drawCircle(context, data.getJoint(JointID.FOOT_LEFT), 10);
			__drawCircle(context, data.getJoint(JointID.FOOT_RIGHT), 10);
			
			__lineTo(context, data.getJoint(JointID.HEAD), data.getJoint(JointID.SHOULDER_CENTER));
			__lineTo(context, data.getJoint(JointID.SHOULDER_LEFT), data.getJoint(JointID.SHOULDER_RIGHT));
			__lineTo(context, data.getJoint(JointID.SHOULDER_LEFT), data.getJoint(JointID.SPINE));
			__lineTo(context, data.getJoint(JointID.SHOULDER_RIGHT), data.getJoint(JointID.SPINE));
			__lineTo(context, data.getJoint(JointID.SPINE), data.getJoint(JointID.HIP_LEFT));
			__lineTo(context, data.getJoint(JointID.SPINE), data.getJoint(JointID.HIP_RIGHT));
			__lineTo(context, data.getJoint(JointID.HIP_LEFT), data.getJoint(JointID.HIP_RIGHT));
			__lineTo(context, data.getJoint(JointID.SHOULDER_LEFT), data.getJoint(JointID.ELBOW_LEFT));
			__lineTo(context, data.getJoint(JointID.ELBOW_LEFT), data.getJoint(JointID.HAND_LEFT));
			__lineTo(context, data.getJoint(JointID.SHOULDER_RIGHT), data.getJoint(JointID.ELBOW_RIGHT));
			__lineTo(context, data.getJoint(JointID.ELBOW_RIGHT), data.getJoint(JointID.HAND_RIGHT));
			__lineTo(context, data.getJoint(JointID.HIP_LEFT), data.getJoint(JointID.KNEE_LEFT));
			__lineTo(context, data.getJoint(JointID.KNEE_LEFT), data.getJoint(JointID.FOOT_LEFT));
			__lineTo(context, data.getJoint(JointID.HIP_RIGHT), data.getJoint(JointID.KNEE_RIGHT));
			__lineTo(context, data.getJoint(JointID.KNEE_RIGHT), data.getJoint(JointID.FOOT_RIGHT));
			
		}
		
		private function __lineTo(context:Sprite, joint:JointsData, joint1:JointsData):void 
		{
			context.graphics.moveTo(joint.x, joint.y);
			context.graphics.lineTo(joint1.x, joint1.y);
		}
		
		private function __drawCircle(context:Sprite, joint:JointsData, number:Number):void 
		{
			context.graphics.drawCircle(joint.x, joint.y, number);
		}
		
	}

}