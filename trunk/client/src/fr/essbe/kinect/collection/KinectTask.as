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
	public class KinectTask extends Object 
	{
		private var __id:int;
		private var __first:int;
		private var __second:int;
		private var __sent:Boolean;
		
		public function KinectTask(first:int, second:int) 
		{
			this.__first = first;
			this.__second = second;
			__sent = false;
		}
		
		public function get second():int 
		{
			return __second;
		}
		
		public function set second(value:int):void 
		{
			__second = value;
		}
		
		public function get first():int 
		{
			return __first;
		}
		
		public function set first(value:int):void 
		{
			__first = value;
		}
		
		public function get sent():Boolean 
		{
			return __sent;
		}
		
		public function set sent(value:Boolean):void 
		{
			__sent = value;
		}
		
		public function get id():int 
		{
			return __id;
		}
		
		public function set id(value:int):void 
		{
			__id = value;
		}
		
		public function reset():void 
		{
			__sent = false;
		}
		
	}

}