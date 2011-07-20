using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Threading;
using System.Collections;

using Microsoft.Research.Kinect.Nui;
using Microsoft.Research.Kinect.Audio;
using Coding4Fun.Kinect.Wpf;

namespace SocketServer
{
    class Server
    {
        const int PORT = 9001;
        const String HOST = "127.0.0.1";
        const float MaxDepthDistance = 4000;
        const float MinDepthDistance = 850;
        const float MaxDepthDistanceOffset = MaxDepthDistance - MinDepthDistance;
        const int BLUE = 0;
        const int GREEN = 1;
        const int RED = 2;

        private Runtime nui;
        private bool run;
        private bool rgb_ready = false;
        private bool depth_ready = false;
        private byte[] buffer;
        private Byte[] message;
        private Socket CurrentClient;
        private bool readLock;
        private ImageFrame CurrentDepth;
        private ImageFrame CurrentRGB;
        private ArrayList skels = new ArrayList();

        private Thread CheckMessage;
        private Thread CheckConnection;

        public void Start()
        {
            run = true;
            Socket serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            try
            {
                CurrentClient = null;

                IPHostEntry ipHostEntry = Dns.GetHostEntry(HOST);
                serverSocket.Bind(new IPEndPoint(ipHostEntry.AddressList[0], PORT));
                serverSocket.Listen(10);

                CheckConnection = new Thread(new ThreadStart(getConnectionStatus));
                CheckConnection.Start();

                Console.WriteLine("Attente d'une nouvelle connexion...");
                while (run)
                {
                    if (CurrentClient == null)
                    {
                        CurrentClient = serverSocket.Accept();
                        Console.WriteLine("Nouveau client:" + CurrentClient.GetHashCode());
                        nui = new Runtime();
                        try
                        {
                            nui.Initialize(RuntimeOptions.UseColor | RuntimeOptions.UseDepthAndPlayerIndex | RuntimeOptions.UseSkeletalTracking);

                            nui.SkeletonEngine.TransformSmooth = true;
                            var parameters = new TransformSmoothParameters
                            {
                                Smoothing = 0.75f,
                                Correction = 0.0f,
                                Prediction = 0.0f,
                                JitterRadius = 0.05f,
                                MaxDeviationRadius = 0.04f
                            };
                            nui.SkeletonEngine.SmoothParameters = parameters;

                            nui.VideoFrameReady += new EventHandler<ImageFrameReadyEventArgs>(nui_VideoFrameReady);
                            nui.DepthFrameReady += new EventHandler<ImageFrameReadyEventArgs>(nui_DepthFrameReady);

                            nui.VideoStream.Open(ImageStreamType.Video, 2, ImageResolution.Resolution640x480, ImageType.Color);
                            nui.DepthStream.Open(ImageStreamType.Depth, 2, ImageResolution.Resolution320x240, ImageType.DepthAndPlayerIndex);

                            nui.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>(nui_SkeletonFrameReady);

                            CheckMessage = new Thread(new ThreadStart(getMessage));
                            CheckMessage.Start();
                           
                        }
                        catch (InvalidOperationException e)
                        {
                            Console.WriteLine(e.Message);
                            Console.WriteLine("Kinect sensor not detected. Have you tried turning it off and on again?");
                            run = false;
                        }
                    }
                }
            }
            catch (SocketException e)
            {
                Console.WriteLine(e.Message);
                run = false;
            }
        }

        void nui_SkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
        {
            //Console.WriteLine("nui_SkeletonFrameReady");
            skels = null;
            skels = new ArrayList();

            SkeletonFrame allSkeletons = e.SkeletonFrame;
            foreach (SkeletonData skel in allSkeletons.Skeletons)
            {
                if (skel.TrackingState == SkeletonTrackingState.Tracked)
                {
                    SkeletonBytes s = new SkeletonBytes();
                    s.Init(skel);
                    skels.Add(s);
                }
            }
        }

        void nui_DepthFrameReady(object sender, ImageFrameReadyEventArgs e)
        {
            //Console.WriteLine("nui_DepthFrameReady");
            if (!depth_ready) depth_ready = true;
            CurrentDepth = e.ImageFrame;
        }

        private byte[] GenerateColoredBytes(ImageFrame imageFrame)
        {
            int width = imageFrame.Image.Width;
            int height = imageFrame.Image.Height;

            Byte[] depthData = imageFrame.Image.Bits;
            Byte[] colorFrame = new byte[width * height * 8];

            var depthId = 0;

            for (var y = 0; y < height; y++)
            {
                var heightOffset = y * width;
                for (var x = 0; x < width; x++)
                {
                    var id = ((width - x - 1) + heightOffset) * 4;
                    int distance = GetDistancePlayerIndex(depthData[depthId], depthData[depthId + 1]);
                    var intensity = CalculateIntensityFromDepth(distance);

                    colorFrame[id + BLUE] = intensity;
                    colorFrame[id + GREEN] = intensity;
                    colorFrame[id + RED] = intensity;

                    if (GetPlayerIndex(depthData[depthId]) == 1)
                    {
                        colorFrame[id + BLUE] = 0;
                        colorFrame[id + GREEN] = intensity;
                        colorFrame[id + RED] = intensity;
                    }

                    if (GetPlayerIndex(depthData[depthId]) == 2)
                    {
                        colorFrame[id + BLUE] = intensity;
                        colorFrame[id + GREEN] = 0;
                        colorFrame[id + RED] = intensity;
                    }
                    depthId += 2;
                }
            }


            return colorFrame;
        }

        private byte[] GenerateBytes(ImageFrame imageFrame)
        {
            int width = imageFrame.Image.Width;
            int height = imageFrame.Image.Height;

            Byte[] depthData = imageFrame.Image.Bits;
            Byte[] depthFrame = new byte[width * height * 8];

            var depthId = 0;

            for (var y = 0; y < height; y++)
            {
                var heightOffset = y * width;
                for (var x = 0; x < width; x++)
                {
                    var id = ((width - x - 1) + heightOffset) * 4;
                    int distance = GetDistancePlayerIndex(depthData[depthId], depthData[depthId + 1]);
                    var intensity = CalculateIntensityFromDepth(distance);

                    depthFrame[id + BLUE] = intensity;
                    depthFrame[id + GREEN] = intensity;
                    depthFrame[id + RED] = intensity;

                    depthId += 2;
                }
            }

            return depthFrame;
        }

        private byte[] GeneratePlayersBytes(ImageFrame imageFrame)
        {
            int width = imageFrame.Image.Width;
            int height = imageFrame.Image.Height;

            Byte[] depthData = imageFrame.Image.Bits;
            Byte[] colorFrame = new byte[width * height * 8];

            var depthId = 0;

            for (var y = 0; y < height; y++)
            {
                var heightOffset = y * width;
                for (var x = 0; x < width; x++)
                {
                    var id = ((width - x - 1) + heightOffset) * 4;
                    int distance = GetDistancePlayerIndex(depthData[depthId], depthData[depthId + 1]);
                    var intensity = CalculateIntensityFromDepth(distance);

                    colorFrame[id + BLUE] = 0;
                    colorFrame[id + GREEN] = 0;
                    colorFrame[id + RED] = 0;

                    if (GetPlayerIndex(depthData[depthId]) == 1)
                    {
                        colorFrame[id + BLUE] = 0;
                        colorFrame[id + GREEN] = intensity;
                        colorFrame[id + RED] = intensity;
                    }

                    if (GetPlayerIndex(depthData[depthId]) == 2)
                    {
                        colorFrame[id + BLUE] = intensity;
                        colorFrame[id + GREEN] = 0;
                        colorFrame[id + RED] = intensity;
                    }
                    depthId += 2;
                }
            }


            return colorFrame;
        }
        
        public static byte CalculateIntensityFromDepth(int distance)
        {
            return (byte)(255 - (255 * Math.Max(distance - MinDepthDistance, 0) / (MaxDepthDistanceOffset)));
        }

        private static int GetPlayerIndex(byte firstFrame)
        {
            return (int)firstFrame & 7;
        }

        private int GetDistancePlayerIndex(byte firstframe, byte secondFrame)
        {
            int distance = (int)(firstframe >> 3 | secondFrame << 5);
            return distance;
        }

        void nui_VideoFrameReady(object sender, ImageFrameReadyEventArgs e)
        {
            //Console.WriteLine("nui_VideoFrameReady");
            if (!rgb_ready) rgb_ready = true;
            CurrentRGB = e.ImageFrame;
        }

        private void getMessage()
        {
            while (true)
            {
                if (CurrentClient != null && rgb_ready && depth_ready)
                {
                    try
                    {
                        ArrayList list = new ArrayList();
                        list.Add(CurrentClient);


                        Socket.Select(list, null, null, 1000);
                        if (CurrentClient.Available > 0)
                        {
                            readLock = true;

                            while (CurrentClient.Available > 0)
                            {
                                buffer = new byte[CurrentClient.Available];
                                CurrentClient.Receive(buffer, buffer.Length, SocketFlags.None);
                                if (BitConverter.IsLittleEndian)
                                    Array.Reverse(buffer);

                                int second = BitConverter.ToInt32(buffer, 0);
                                int first = BitConverter.ToInt32(buffer,4);
                                switch (first)
                                {
                                    case 0:
                                        //CAMERA
                                        switch (second)
                                        {
                                            case 0:
                                                //DEPTH
                                                sendMessage(GenerateBytes(CurrentDepth));
                                                break;

                                            case 1:
                                                //PLAYERS
                                                sendMessage(GeneratePlayersBytes(CurrentDepth));
                                                break;

                                            case 2:
                                                //DEPTH & PLAYERS
                                                sendMessage(GenerateColoredBytes(CurrentDepth));
                                                break;

                                            case 3:
                                                //RGB
                                                sendMessage(CurrentRGB.Image.Bits);
                                                break;

                                            case 4:
                                                //SKELETONS
                                                Byte[] data;
                                                if (skels != null && skels.Count > 0)
                                                {
                                                    data = new byte[skels.Count * (16 * 20 + 4)];
                                                    int pos = 0;
                                                    foreach (SkeletonBytes s in skels)
                                                    {
                                                        //data = s.GetBytes();
                                                        //data.CopyTo(s.GetBytes(), pos);
                                                        for (int i = 0; i < 324; i++)
                                                        {
                                                            data[(pos + i)] = s.GetBytes()[i];
                                                        }
                                                        pos += s.GetBytes().Length;
                                                    }
                                                   sendMessage(data);
                                                    //Console.WriteLine("sent : " + skelSent);
                                                }
                                                else
                                                {
                                                    //Console.WriteLine("No skeletons detected");
                                                    data = new byte[4];
                                                    data = BitConverter.GetBytes((int)1);
                                                    
                                                    ArrayList dest = new ArrayList();
                                                    dest.Add(CurrentClient);

                                                    Socket.Select(null, dest, null, 50);
                                                    CurrentClient.Send(data);
                                                }
                                                break;
                                        }
                                        break;

                                    case 1:
                                        //MOTOR
                                        switch (second)
                                        {
                                            case 0:
                                                //SET TILT
                                                
                                                break;
                                        }
                                        break;

                                    case 2:
                                        //MIC
                                        break;

                                    default:
                                        break;
                                }
                            }

                            readLock = false;

                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                    }
                }

                Thread.Sleep(10);
            }
        }

        private int sendMessage(byte[] message)
        {
            ArrayList dest = new ArrayList();
            dest.Add(CurrentClient);

            Socket.Select(null, dest, null, 50);

            try
            {
                int total = 0;
                int size = message.Length;
                int dataLeft = size;
                int sent;

                byte[] datasize = new byte[4];
                datasize = BitConverter.GetBytes(size);
                sent = CurrentClient.Send(datasize);
                
                while (total < size)
                {
                    sent = CurrentClient.Send(message, total, dataLeft, SocketFlags.None);
                    total += sent;
                    dataLeft -= sent;
                }
                return total;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return 0;
            }
        }

        private void getConnectionStatus()
        {
            while (true)
            {
               if (CurrentClient != null && CurrentClient.Poll(10000, SelectMode.SelectWrite) && CurrentClient.Available == 0)
                {
                    if (!readLock)
                    {
                        /*nui.Uninitialize();
                        nui = null;

                        depth_ready = rgb_ready = false;

                        CurrentClient.Close();
                        CurrentClient = null;

                        CheckMessage.Abort();

                        Console.WriteLine("Deconnexion");
                        Console.WriteLine("Attente d'une nouvelle connexion...");*/
                    }
                }
                Thread.Sleep(30);
            }

        }

    }


}
