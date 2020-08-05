# Use ubuntu 20.04
FROM ros:eloquent-ros-base
LABEL maintainer="Julian Narr"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq wget curl git build-essential vim sudo lsb-release locales bash-completion tzdata &&\
    apt-get install -yq apt-transport-https

# Install doxygen, cpplint + python packages
RUN apt-get install -y doxygen
RUN apt-get install -y python3 python3-pip libboost-dev lcov
RUN pip3 install colcon-lcov-result
RUN apt-get -y install cmake python-catkin-pkg python-empy python-nose python-setuptools libgtest-dev build-essential
RUN pip3 install cpplint
RUN apt-get install -y libyaml-cpp-dev 
RUN apt-get install -y ros-eloquent-camera-info-manager
RUN apt-get install -y libopencv-dev
RUN apt install libboost-all-dev

# Finish colcon-common-extensions
RUN pip3 install colcon-common-extensions
RUN pip3 install pytest==5.0
RUN pip3 install setuptools==40.0
RUN pip3 install colcon-common-extensions
RUN pip3 install -U PyYAML   
RUN pip3 install numpy
RUN pip3 install natsort
RUN pip3 install opencv-python 

# install opencv
WORKDIR /root
RUN mkdir opencv_build
WORKDIR /root/opencv_build
RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git
WORKDIR /root/opencv_build/opencv
RUN mkdir build
WORKDIR /root/opencv_build/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..
RUN make -j $(nproc)
RUN make install

#Install OpenCV bridge
WORKDIR /root
RUN git clone https://github.com/ros-perception/vision_opencv.git
WORKDIR /root/vision_opencv
RUN git checkout ros2
Run git branch
#RUN sudo apt install libboost-python1.58.0
#RUN /bin/bash -c "source /opt/ros/eloquent/setup.bash"
#RUN  /bin/bash -c "colcon build --symlink-install"
#RUN /bin/bash -c "source ./install/setup.bash"

#Install video stream
WORKDIR /root
RUN git clone https://github.com/julian533/ros2_usb_camera
Run cd ros2_usb_camera
#Run colcon build --symlink-install
#RUN /bin/bash -c "source ./install/setup.bash"

#Install  image_transport_plugins
WORKDIR /root
Run git clone https://github.com/ros-perception/image_transport_plugins.git

# Reset workdir to home-folder
WORKDIR /root

# Source again
RUN /bin/bash -c "source /opt/ros/eloquent/setup.bash"

# Remove apt lists (for storage efficiency)
#RUN rm -rf /var/lib/apt/lists/*

CMD ["bash"]
