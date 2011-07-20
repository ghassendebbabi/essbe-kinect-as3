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