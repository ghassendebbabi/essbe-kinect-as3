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
	/**
	 * ...
	 * @author ...
	 */
	public class KinectData extends Object 
	{
		
		private var __first:int;
		private var __second:int;
		private var __buffer:ByteArray;
		
		public function KinectData() 
		{
			super();
		}
		
		public function get first():int 
		{
			return __first;
		}
		
		public function set first(value:int):void 
		{
			__first = value;
		}
		
		public function get second():int 
		{
			return __second;
		}
		
		public function set second(value:int):void 
		{
			__second = value;
		}
		
		public function get buffer():ByteArray 
		{
			return __buffer;
		}
		
		public function set buffer(value:ByteArray):void 
		{
			__buffer = value;
		}
		
	}

}