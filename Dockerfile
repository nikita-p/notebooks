FROM andrewosh/binder-base

MAINTAINER Omar Zapata <Omar.Zapata@cern.ch>

USER root

# Install ROOT prerequisites
RUN apt update
### Core
RUN apt -y install git cmake gcc g++ gfortran doxygen
### X libraries
RUN apt -y install libx11-dev libxext-dev libxft-dev libxpm-dev
### Python
RUN apt -y install python3-dev python3-numpy-dev python3-pip python3-scipy python3-matplotlib
### Python installed with pip
#RUN pip3 install metakernel --ignore-installed
#RUN pip3 install zmq --ignore-installed
### Math libraries
RUN apt -y install libgsl0-dev
### Other libraries
RUN apt -y install libxml2-dev

# Download and install ROOT master
WORKDIR /opt
RUN wget http://root.cern.ch/notebooks/rootbinderdata/root.tar.gz 
RUN tar xzf root.tar.gz
RUN rm root.tar.gz

WORKDIR /home/main

# Set ROOT environment
ENV ROOTSYS         "/opt/root"
ENV PATH            "$ROOTSYS/bin:$ROOTSYS/bin/bin:$PATH"
ENV LD_LIBRARY_PATH "$ROOTSYS/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH      "$ROOTSYS/lib:$ROOTSYS/lib/JupyROOT:$PYTHONPATH"

# Customise the JupyROOT environment
RUN mkdir -p $HOME/.ipython/kernels $HOME/.ipython/profile_default/static
RUN cp -r $ROOTSYS/etc/notebook/kernels/root $HOME/.ipython/kernels
RUN cp -r $ROOTSYS/etc/notebook/custom       $HOME/.ipython/profile_default/static
