#!/usr/bin/env python
from __future__ import print_function
import rospy
from sensor_msgs.msg import TimeReference
from sensor_msgs.msg import Image
from skimage.transform import resize
import numpy as np
import base64

pub = rospy.Publisher('resizedImage', TimeReference, queue_size=10)

def ImageCallbackResize(Imagedata):
	ResizedImage = TimeReference()
	img = np.array(list(map(ord,list(Imagedata.data)))).astype("uint8")
	img = np.reshape(img[::-1], (Imagedata.height,Imagedata.width))
	img = resize(img,(128,128), preserve_range=True ,mode='constant',anti_aliasing=True)
	img = np.reshape(img,(1,16384)).astype("uint8")
	img_byte = img.tobytes()
	ResizedImage.source = base64.b64encode(img_byte)
	ResizedImage.header = Imagedata.header
	pub.publish(ResizedImage)

def main():
	rospy.init_node('imagePub', anonymous=True)
	rospy.Subscriber("/pylon_camera_node/image_raw", Image, ImageCallbackResize)
	rospy.spin()

if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
