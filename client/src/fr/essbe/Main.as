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

package fr.essbe
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import fr.essbe.kinect.collection.KinectTask;
	import fr.essbe.kinect.data.JointsData;
	import fr.essbe.kinect.data.KinectUtils;
	import fr.essbe.kinect.data.SkeletonData;
	import fr.essbe.kinect.display.SimpleSkeleton;
	import fr.essbe.kinect.events.KinectEvent;
	import fr.essbe.kinect.Kinect;
	
	/**
	 * ...
	 * @author essbe
	 */
	public class Main extends Sprite 
	{
		private var sock:Socket;
		private var __k:Kinect;
		private var __bdDepth:BitmapData;
		private var __bdPlayers:BitmapData;
		private var __bdDepthPlayers:BitmapData;
		private var __bdRgb:BitmapData;
		private var __skelSurface:Sprite;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		
			__bdDepth = new BitmapData(KinectUtils.DEPTH_WIDTH, KinectUtils.DEPTH_HEIGHT, false, 0);
			addChild(new Bitmap(__bdDepth));
			
			__bdPlayers = new BitmapData(KinectUtils.DEPTH_WIDTH, KinectUtils.DEPTH_HEIGHT, false, 0);
			var players:Bitmap = Bitmap(addChild(new Bitmap(__bdPlayers)));
			players.x = __bdDepth.width + 10;
			
			__bdDepthPlayers = new BitmapData(KinectUtils.DEPTH_WIDTH, KinectUtils.DEPTH_HEIGHT, false, 0);
			var depthPlayers:Bitmap = Bitmap(addChild(new Bitmap(__bdDepthPlayers)));
			depthPlayers.x = players.x + players.width + 10;
			
			__bdRgb = new BitmapData(KinectUtils.IMG_WIDTH, KinectUtils.IMG_HEIGHT, false, 0)
			var rgb:Bitmap = Bitmap(addChild(new Bitmap(__bdRgb)));
			rgb.y = __bdDepth.height + 10;
			
			__skelSurface = Sprite(addChild(new Sprite()));
			__skelSurface.x = rgb.x;
			__skelSurface.y = rgb.y;
			
			__k = new Kinect();
			__k.addEventListener(KinectEvent.ON_DEPTH, __onDepth);
			__k.addEventListener(KinectEvent.ON_PLAYERS, __onPlayers);
			__k.addEventListener(KinectEvent.ON_DEPTH_PLAYERS, __onDepthPlayers);
			__k.addEventListener(KinectEvent.ON_RGB, __onRGB);
			__k.addEventListener(KinectEvent.ON_SKELETON, __onSkeleton);
			
			__k.addTask(new KinectTask(KinectUtils.CAMERA, KinectUtils.GET_DEPTH));
			__k.addTask(new KinectTask(KinectUtils.CAMERA, KinectUtils.GET_PLAYERS));
			__k.addTask(new KinectTask(KinectUtils.CAMERA, KinectUtils.GET_DEPTH_PLAYERS));
			__k.addTask(new KinectTask(KinectUtils.CAMERA, KinectUtils.GET_RGB));
			__k.addTask(new KinectTask(KinectUtils.CAMERA, KinectUtils.GET_SKEL));
			
			stage.addEventListener(Event.ENTER_FRAME, __onEnterFrame);
		}
		
		private function __onSkeleton(e:KinectEvent):void 
		{
			__skelSurface.graphics.clear();
			var skels:Vector.<SkeletonData> = KinectUtils.processSkeletons(e.data);
			skels.forEach(__drawSkeleton);
		}
		
		private function __drawSkeleton(item:SkeletonData, id:int, v:Vector.<SkeletonData>):void 
		{
			var skel:SimpleSkeleton = new SimpleSkeleton(item, __skelSurface);
		}
		
		private function __onRGB(e:KinectEvent):void 
		{
			__bdRgb.lock();
			__bdRgb.setPixels(__bdRgb.rect, e.data.buffer);
			__bdRgb.unlock();
		}
		
		private function __onPlayers(e:KinectEvent):void 
		{
			__bdPlayers.lock();
			__bdPlayers.setPixels(__bdPlayers.rect, e.data.buffer);
			__bdPlayers.unlock();
		}
		
		private function __onDepthPlayers(e:KinectEvent):void 
		{
			__bdDepthPlayers.lock();
			__bdDepthPlayers.setPixels(__bdDepthPlayers.rect, e.data.buffer);
			__bdDepthPlayers.unlock();
		}
		
		private function __onDepth(e:KinectEvent):void 
		{
			__bdDepth.lock();
			__bdDepth.setPixels(__bdDepth.rect, e.data.buffer);
			__bdDepth.unlock();
		}
		
		private function __onEnterFrame(e:Event):void 
		{
			__k.render();
		}
		
	}
	
}