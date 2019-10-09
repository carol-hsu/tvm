FROM ubuntu:18.04

ARG DEFAULT_WORKDIR=/tvm


RUN apt-get update && apt-get install -y --no-install-recommends \
	software-properties-common \
	lsb-core \
	git \
	python3 \
	python3-dev \
	python3-setuptools \
	python3-pip \
	gcc \
	libtinfo-dev \ 
	zlib1g-dev \
	build-essential \
	cmake \
	wget \
	tar \
	libxml2-dev
#	gpg-agent \
#	llvm-9-dev

#RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

WORKDIR /opt

RUN wget http://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz && \
	tar xvf clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz && \
	rm clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz

WORKDIR /
RUN git clone --recursive https://github.com/dmlc/tvm

WORKDIR $DEFAULT_WORKDIR
RUN mkdir build
COPY docker.config.cmake build/config.cmake

WORKDIR $DEFAULT_WORKDIR/build
RUN cmake .. && make -j4

## is this useful...
ENV PYTHONPATH $DEFAULT_WORKDIR/python:$DEFAULT_WORKDIR/topi/python:$DEFAULT_WORKDIR/nnvm/python:${PYTHONPATH}
# install everything mentioned on official website
RUN python3 -m pip install numpy decorator attrs


