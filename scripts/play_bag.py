#!/usr/bin/env python

import rospy
#import os
import subprocess
from std_msgs.msg import String
from std_msgs.msg import Bool


pub = rospy.Publisher('/bagEnd', Bool, queue_size=10)

def PlayBagFile(Bagdata):
	bagFinish = Bool()
	bagFinish.data = False
	rospy.loginfo("playing ROS bag : "+Bagdata.data)
	output = subprocess.check_output('rosbag play '+Bagdata.data, shell=True)
	rospy.loginfo("Finished playing ROS bag")
	#os.system('rosbag play '+Bagdata)
	bagFinish.data = True
	pub.publish(bagFinish)


def main():
	rospy.init_node('HandleBag', anonymous=True)
	rospy.Subscriber("/bagStart", String, PlayBagFile)
	rospy.spin()

if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
