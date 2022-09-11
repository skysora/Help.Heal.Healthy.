FROM nvidia/cuda:10.1-base 
RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common 
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.7 -y
RUN apt install curl -y
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python3.7 get-pip.py
RUN pip3 install --upgrade pip
COPY ./requirements.txt /requirements.txt 
RUN pip3 install -r /requirements.txt

# RUN apt install make git g++ -y
RUN apt install libglu1 -y
RUN apt install cmake -y
# RUN apt install -y libopencv-dev python3-opencv 
RUN apt install libomp-dev -y
RUN apt install vim -y
# RUN apt install build-essential cmake git pkg-config libgtk-3-dev \
#     libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
#     libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
#     gfortran openexr libatlas-base-dev python3-dev python3-numpy \
#     libtbb2 libtbb-dev libdc1394-22-dev
WORKDIR /flask-app
CMD python3.7 /flask-app/app.py
