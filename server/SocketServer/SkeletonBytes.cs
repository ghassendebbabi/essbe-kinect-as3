using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Microsoft.Research.Kinect.Nui;
using Coding4Fun.Kinect.Wpf;

namespace SocketServer
{
    class SkeletonBytes
    {
        Byte[] bytes;
        int pos;

        public void Init(SkeletonData data)
        {
            pos = 0;

            bytes = new byte[(16 * 20 + 4)];
            copyTo(bytes, data.UserIndex, pos);
            pos += 4;

            addJoint(data.Joints[JointID.Head]);
            addJoint(data.Joints[JointID.ShoulderLeft]);
            addJoint(data.Joints[JointID.ShoulderCenter]);
            addJoint(data.Joints[JointID.ShoulderRight]);
            addJoint(data.Joints[JointID.ElbowLeft]);
            addJoint(data.Joints[JointID.ElbowRight]);
            addJoint(data.Joints[JointID.WristLeft]);
            addJoint(data.Joints[JointID.WristRight]);
            addJoint(data.Joints[JointID.HandLeft]);
            addJoint(data.Joints[JointID.HandRight]);
            addJoint(data.Joints[JointID.Spine]);
            addJoint(data.Joints[JointID.HipLeft]);
            addJoint(data.Joints[JointID.HipCenter]);
            addJoint(data.Joints[JointID.HipRight]);
            addJoint(data.Joints[JointID.KneeLeft]);
            addJoint(data.Joints[JointID.KneeRight]);
            addJoint(data.Joints[JointID.AnkleLeft]);
            addJoint(data.Joints[JointID.AnkleRight]);
            addJoint(data.Joints[JointID.FootLeft]);
            addJoint(data.Joints[JointID.FootRight]);

        }

        private void addJoint(Joint joint)
        {
            joint = joint.ScaleTo(640, 480);
            //Console.WriteLine(joint.ID + " // " + (int)joint.Position.X + " - " + (int)joint.Position.Y + " - " + (int)joint.Position.Z);
            
            copyTo(bytes, (int)joint.Position.X, pos);
            pos += 4;

            copyTo(bytes, (int)joint.Position.Y, pos);
            pos += 4;

            copyTo(bytes, (int)joint.Position.Z, pos);
            pos += 4;

            copyTo(bytes, (int)joint.Position.W, pos);
            pos += 4;
        }

        private void copyTo(byte[] bytes, int p, int pos)
        {
            byte[] val = new byte[4];
            val = BitConverter.GetBytes(p);
            for (int i = 0; i < val.Length; i++)
            {
                bytes[(pos + i)] = val[i];
            }
        }

        public byte[] GetBytes()
        {
            return bytes;
        }

    }
}
