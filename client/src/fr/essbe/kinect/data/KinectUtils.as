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
	import flash.utils.ByteArray;
	import fr.essbe.kinect.data.KinectData;
	/**
	 * ...
	 * @author EssBe
	 */
	public class KinectUtils
	{
		public static const SERVER_IP:String = "localhost";
		public static const SOCKET_PORT:int = 9001;

		public static const CAMERA:int = 0;
		public static const MOTOR:int = 1;
		public static const MIC:int = 2;
		
		public static const GET_DEPTH:int = 0;
		public static const GET_PLAYERS:int = 1;
		public static const GET_DEPTH_PLAYERS:int = 2;
		public static const GET_RGB:int = 3;
		public static const GET_SKEL:int = 4;
		
		public static const SET_TILT:int = 0;
		
		public static const IMG_WIDTH:int = 640;
		public static const IMG_HEIGHT:int = 480;
		public static const DEPTH_WIDTH:int = 320;
		public static const DEPTH_HEIGHT:int = 240;

		public static const TILT_MIN:int = -27;
		public static const TILT_MAX:int = 27;
		
		public function KinectUtils() { }
		
		/**
		 * 
		 * @param	percent int from 0 to 100
		 * @return the tilt value to set
		 */
		public function getTiltValue(percent:int):int
		{
			return int((percent * TILT_MAX * 2 - TILT_MIN) / 100);
		}
		
		static public function processSkeletons(data:KinectData):Vector.<SkeletonData> 
		{
			if (data.first == CAMERA && data.second == GET_SKEL)
			{
				var vec:Vector.<SkeletonData> = new Vector.<SkeletonData>();
				var num:int = Math.floor(data.buffer.length / 324);
				if (num > 0)
				{
					for (var i:int = 0; i < num; i++)
					{
						var ba:ByteArray = new ByteArray();
						ba.writeBytes(data.buffer, i * 324, 324);
						vec.push(new SkeletonData(ba));
					}
				}
				return vec;
			}
			else
			{
				throw(new Error("You must process skeleton data."));
			}
			return null;
		}
		
	}

}