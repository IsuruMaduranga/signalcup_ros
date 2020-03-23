FROM ros:melodic-ros-base-bionic

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

RUN source ~/.bashrc

RUN apt-get install -y ros-melodic-rosbridge-server

RUN pip install rospkg==1.2.3

RUN pip install scikit-Image==0.14.5

WORKDIR /signalcup_ws/src

RUN catkin_create_pkg getdata rospy roscpp std_msgs

WORKDIR /signalcup_ws/src/getdata

RUN rm -rf include include && rm -rf src

COPY . . 

WORKDIR /signalcup_ws

RUN catkin_make

WORKDIR /signalcup_ws/devel

CMD source setup.bash

ENTRYPOINT ["roslaunch getdata getdata.launch"]

