FROM ros:melodic-ros-base-bionic

RUN apt update

RUN apt-get install -y ros-melodic-rosbridge-server

RUN apt install -y python-pip

RUN pip install rospkg==1.2.3

RUN pip install scikit-Image==0.14.5

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash"

WORKDIR /signalcup_ws/src

RUN catkin_create_pkg getdata rospy roscpp std_msgs

WORKDIR /signalcup_ws/src/getdata

RUN rm -rf include include && rm -rf src

COPY . . 

WORKDIR /signalcup_ws

RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /signalcup_ws ; catkin_make'

WORKDIR /

COPY ./entry.sh /

ENTRYPOINT ["/entry.sh"]

CMD roslaunch getdata getdata.launch

