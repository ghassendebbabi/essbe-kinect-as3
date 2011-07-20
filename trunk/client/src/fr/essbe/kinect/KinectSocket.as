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
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import fr.essbe.kinect.collection.KinectTask;
	import fr.essbe.kinect.data.KinectData;
	import fr.essbe.kinect.data.KinectUtils;
	import fr.essbe.kinect.events.KinectSocketEvent;
	
	/**
	 * ...
	 * @author EssBe
	 */
	//[Event (name="onData", type="fr.essbe.kinect.events.KinectSocketEvent")]
	 
	public class KinectSocket extends EventDispatcher
	{
		
		private static var __oI:KinectSocket;
		public static function getInstance():KinectSocket
		{
			if (!__oI) __oI = new KinectSocket(new ConstructorAccess());
			return __oI;
		}
		
		private var __socket:Socket;
		private var __packet_size:Number;
		
		private var __buffer:ByteArray;
		private var __data:KinectData;
		private var __currentTask:KinectTask;
		private var __readLock:Boolean;
		private var __timer:Timer;
		
		public function KinectSocket(o:ConstructorAccess) 
		{
			super();
			
			__buffer = new ByteArray();
			__data = new KinectData();

			__createSocket();
			
			__packet_size = 0;
			
		}
		
		private function __createSocket():void 
		{
			__socket = new Socket();
			__socket.addEventListener(ProgressEvent.SOCKET_DATA, __onSocketData);
			__socket.addEventListener(IOErrorEvent.IO_ERROR, __onSocketError);
		}
		
		private function __onSocketError(e:IOErrorEvent):void 
		{
			trace( "KinectSocket.__onSocketError > e : " + e );
		}
		
		private function __onSocketData(e:ProgressEvent):void 
		{
			if (__socket.bytesAvailable > 0 && !__readLock) 
			{
				if (__packet_size == 0)
				{
					__socket.endian = Endian.LITTLE_ENDIAN;
					__packet_size = __socket.readInt();
					
					__buffer.endian = Endian.LITTLE_ENDIAN;
					__buffer.position = 0;
					if (__packet_size == 1)
					{
						__data.first = __currentTask.first;
						__data.second = __currentTask.second;
						__packet_size = 0;
						
						dispatchEvent(new KinectSocketEvent(KinectSocketEvent.ONDATA, __data));
						__readLock = true;
					}
					else if (__packet_size > 1 && __packet_size == __socket.bytesAvailable)
					{
						__socket.readBytes(__buffer, __buffer.length, __socket.bytesAvailable);
						__data.first = __currentTask.first;
						__data.second = __currentTask.second;
						__data.buffer = __buffer;
						__packet_size = 0;
						
						dispatchEvent(new KinectSocketEvent(KinectSocketEvent.ONDATA, __data));
						__readLock = true;
					}
				}
				else
				{
					__socket.readBytes(__buffer, __buffer.length, __socket.bytesAvailable);
					if (__buffer.length >= __packet_size)
					{
						__data.first = __currentTask.first;
						__data.second = __currentTask.second;
						__data.buffer = __buffer;
						__packet_size = 0;
						
						dispatchEvent(new KinectSocketEvent(KinectSocketEvent.ONDATA, __data));
						__readLock = true;
					}
				}
			}
		}
		
		public function connect(ip:String, port:int):void
		{
			__socket.connect(ip, port);
		}
		
		public function sendCommand(task:KinectTask):void 
		{
			__readLock = false;
			__currentTask = task;
			__currentTask.sent = true;
			
			var data:ByteArray = new ByteArray();
			data.writeInt(__currentTask.first);
			data.writeInt(__currentTask.second);
			
			try
			{
				__socket.writeBytes(data, 0, data.length);
				__socket.flush();
			}
			catch (e:Error)
			{
				trace("Socket error : " + e);
				
				__waitAndRetry();
				connect(KinectUtils.SERVER_IP, KinectUtils.SOCKET_PORT);
			}
			
		}
		
		private function __waitAndRetry():void 
		{
			__resetTimer();
			__timer = new Timer(1000, 1);
			__timer.addEventListener(TimerEvent.TIMER_COMPLETE, __onTimerComplete);
			__timer.start();
		}
		
		private function __resetTimer():void 
		{
			if (__timer)
			{
				__timer.stop();
				__timer.removeEventListener(TimerEvent.TIMER_COMPLETE, __onTimerComplete);
				__timer = null;
			}
		}
		
		private function __onTimerComplete(e:TimerEvent):void 
		{
			if (__socket)
			{
				__socket.close();
				__socket.removeEventListener(IOErrorEvent.IO_ERROR, __onSocketError);
				__socket.removeEventListener(ProgressEvent.SOCKET_DATA, __onSocketData);
				__socket = null;
			}
			__createSocket();
			connect(KinectUtils.SERVER_IP, KinectUtils.SOCKET_PORT);
		}
		
	}

}

internal class ConstructorAccess
{
	
}