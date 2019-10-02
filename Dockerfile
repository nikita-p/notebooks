FROM atlas/athanalysis:21.2.40
RUN echo bust cache
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/lcg/zeromq/4.1.6-b4186/x86_64-slc6-gcc62-opt/lib' >> /home/atlas/setup.sh 
RUN source ~/release_setup.sh && pip install -U metakernel --user
RUN source /home/atlas/release_setup.sh && cp -r $ROOTSYS/etc/notebook/kernels/root ~/.local/share/jupyter/kernels
RUN echo 'export PATH=$PATH:$HOME/.local/bin' >> /home/atlas/setup.sh
