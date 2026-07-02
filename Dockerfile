# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images_ros2/create_ros_core_image.Dockerfile.em
FROM ubuntu:focal

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    ca-certificates \
    curl \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*


# setup keys
RUN set -eux; \
       key='4B63CF8FDE49746E98FA01DDAD19BAB3CBF125EA'; \
       export GNUPGHOME="$(mktemp -d)"; \
       gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
       mkdir -p /usr/share/keyrings; \
       gpg --batch --export "$key" > /usr/share/keyrings/ros2-snapshots-archive-keyring.gpg; \
       gpgconf --kill all; \
       rm -rf "$GNUPGHOME"

# setup sources.list
RUN echo "deb [ signed-by=/usr/share/keyrings/ros2-snapshots-archive-keyring.gpg ] http://snapshots.ros.org/foxy/final/ubuntu focal main" > /etc/apt/sources.list.d/ros2-snapshots.list

# setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV ROS_DISTRO=foxy

    
# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update   

    
# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-desktop=0.9.2-1* \
    && rm -rf /var/lib/apt/lists/*  



# 设置上海时区
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone


# 安装OS基础软件
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    vim \
    usbutils \
    pciutils \
    iputils-ping \
    net-tools \
    iproute2 \
    tree \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*


# 安装 Rosmaster_Lib 驱动库
COPY py_install_V3.3.9.zip /tmp/

RUN cd /tmp && \
    unzip py_install_V3.3.9.zip && \
    cd py_install && \
    python3 setup.py install && \
    cd / && \
    rm -rf /tmp/py_install /tmp/py_install_V3.3.9.zip

# 安装 Speech_Lib 驱动库
COPY py_install_V0.0.1.zip /tmp/

RUN cd /tmp && \
    unzip py_install_V0.0.1.zip && \
    cd py_install && \
    python3 setup.py install && \
    cd / && \
    rm -rf /tmp/py_install /tmp/py_install_V0.0.1.zip

# 安装用于串口通信（Serial）的 Python 库
RUN python3 -m pip install --no-cache-dir \
    pyserial

# 安装 opencv
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*
    
# 安装 numpy
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-numpy \
    && rm -rf /var/lib/apt/lists/*
    
# 安装 jupyterlab
RUN python3 -m pip install --no-cache-dir \
    pyzmq==25.0.0 \
    jupyterlab==3.6.1

# 安装 qrcode pyzbar
RUN python3 -m pip install --no-cache-dir \
    qrcode \
    pyzbar

# 安装 libzbar-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzbar-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装标定的功能包camera_calibration
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-camera-calibration* \
    && rm -rf /var/lib/apt/lists/*

# 安装 pcl-tools 用于 pcl_viewer 命令
RUN apt-get update && apt-get install -y --no-install-recommends \
    pcl-tools \
    && rm -rf /var/lib/apt/lists/*

# 安装 libuvc
RUN apt-get update && apt-get install -y --no-install-recommends \
    libuvc-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 dlib
RUN python3 -m pip install --no-cache-dir \
    dlib==19.24.9
    
# 安装 libgoogle-glog-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgoogle-glog-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 rosbridge-suite 和 rosbridge-test-msgs
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-rosbridge-suite \
    ros-foxy-rosbridge-test-msgs \
    && rm -rf /var/lib/apt/lists/*

# 安装 ros-foxy-usb-cam
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-usb-cam \
    && rm -rf /var/lib/apt/lists/*

# 安装 ros-foxy-async-web-server-cpp
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-async-web-server-cpp \
    && rm -rf /var/lib/apt/lists/*
    
    



# 添加环境变量
RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc

# setup entrypoint
COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
