FROM ubuntu:bionic

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list

RUN apt-get update && apt-get install -y \
    ros-melodic-ros-base=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init \
    && rosdep update

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

