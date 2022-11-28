FROM ros:foxy

RUN mkdir -p /ros2_ws/src

COPY . /ros2_ws/src/.

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && rosdep install -y \
      --from-paths \
        ros2_ws/src \
      --ignore-src -r \
    && rm -rf /var/lib/apt/lists/*
    
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd /ros2_ws && \
    colcon build --symlink-install
    
RUN sed --in-place --expression \
      '$isource "/ros2_ws/install/setup.bash"' \
      /ros_entrypoint.sh

RUN apt-get update && apt-get install -y \
	  ros-foxy-turtlebot3-teleop \
      ros-foxy-image-view \
    && rm -rf /var/lib/apt/lists/*
          
# launch ros package
CMD ["ros2", "launch", "turtlebot3_gazebo", "turtlebot3_house.launch.py"]
