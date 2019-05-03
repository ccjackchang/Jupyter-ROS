FROM osrf/ros:kinetic-desktop-xenial

SHELL ["/bin/bash","-c"]

# install ros packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    ros-kinetic-desktop-full=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

ENV CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS/src

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && apt-get update \
    && cd $CATKIN_WS \
    && catkin_make

RUN apt-get update && apt-get install -y python3 python3-pip
RUN apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get -y install nodejs

RUN pip3 install jupyter ipywidgets jupyterlab bqplot pyyaml jupyros 
RUN jupyter labextension install jupyter-ros
RUN jupyter nbextension enable --py --sys-prefix jupyros
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

COPY ./ros_catkin_entrypoint.sh /
COPY ./jupyter-ros /root/
ENTRYPOINT ["/ros_catkin_entrypoint.sh"]
CMD ["bash"]
