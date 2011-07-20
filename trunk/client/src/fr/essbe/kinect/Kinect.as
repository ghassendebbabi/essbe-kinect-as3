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

package fr.essbe.kinect 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import fr.essbe.kinect.collection.KinectStack;
	import fr.essbe.kinect.collection.KinectTask;
	import fr.essbe.kinect.data.KinectData;
	import fr.essbe.kinect.data.KinectUtils;
	import fr.essbe.kinect.events.KinectEvent;
	import fr.essbe.kinect.events.KinectSocketEvent;
	/**
	 * ...
	 * @author EssBe
	 */
	public class Kinect extends EventDispatcher
	{
		
		private var __socket:KinectSocket;
		private var __data:ByteArray;
		
		private var __stack:KinectStack;
		private var __currentTask:KinectTask;
		private var __waiting:Boolean;
		
		public function Kinect() 
		{
			Security.allowDomain(KinectUtils.SERVER_IP);
			
			__stack = new KinectStack();
			
			__socket = KinectSocket.getInstance();
			__socket.addEventListener(KinectSocketEvent.ONDATA, __onSocketData);
			__socket.connect(KinectUtils.SERVER_IP, KinectUtils.SOCKET_PORT);
			
			__data = new ByteArray();
		}
		
		public function addTask(kinectTask:KinectTask):void 
		{
			__stack.add(kinectTask);
		}
		
		public function render():void 
		{
			if (__waiting) return;
			__currentTask = __stack.getNext();
			if (__currentTask != null)
			{
				__waiting = true;
				__socket.sendCommand(__currentTask);
			}
			else
			{
				for each(var task:KinectTask in __stack.getTasks())
				{
					task.reset();
				}
			}
		}
		
		private function __onSocketData(e:KinectSocketEvent):void 
		{
			__waiting = false;
			
			var data:KinectData = e.data;
			switch(data.first)
			{
				case KinectUtils.CAMERA:
					__onCameraData(data);
				break;
				
				case KinectUtils.MOTOR:
					__onMotorData(data);
				break;
				
				case KinectUtils.MIC:
					__onMicData(data);
				break;
				
				default:
			}
			if(data.buffer) data.buffer.clear();
			data = null;
		}
		
		private function __onMicData(data:KinectData):void 
		{
			
		}
		
		private function __onMotorData(data:KinectData):void 
		{
			
		}
		
		private function __onCameraData(data:KinectData):void 
		{
			switch(data.second)
			{
				case KinectUtils.GET_DEPTH:
					dispatchEvent(new KinectEvent(KinectEvent.ON_DEPTH, data));
					break;
					
				case KinectUtils.GET_PLAYERS:
					dispatchEvent(new KinectEvent(KinectEvent.ON_PLAYERS, data));
					break;
					
				case KinectUtils.GET_DEPTH_PLAYERS:
					dispatchEvent(new KinectEvent(KinectEvent.ON_DEPTH_PLAYERS, data));
					break;
					
				case KinectUtils.GET_RGB:
					dispatchEvent(new KinectEvent(KinectEvent.ON_RGB, data));
					break;
					
				case KinectUtils.GET_SKEL:
					dispatchEvent(new KinectEvent(KinectEvent.ON_SKELETON, data));
					break;
					
				default:
			}
		}
		
	}

}