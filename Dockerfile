FROM jupyter/tensorflow-notebook

USER root
# install dependencies 
RUN apt-get update && apt-get install -yq --no-install-recommends \
    php-cli php-dev php-pear \
    pkg-config \
    && apt-get clean

# install ijavascript
RUN apt-get install -yq --no-install-recommends nodejs-legacy npm libzmq3-dev && \
    npm install -g ijavascript && \
    ijs --ijs-install=global

RUN cd .. && \
    wget https://root.cern.ch/download/cling/cling_2017-09-15_ubuntu16.tar.bz2 && \
    tar -xvjf cling_2017-09-15_ubuntu16.tar.bz2 && \
    rm cling_*.tar.bz2 && \
    mv cling_* cling

RUN cd .. && \
    ln -s $(pwd)/cling/bin/* /usr/bin/ && \
    cd cling/share/cling/Jupyter/kernel && \
    pip install -e . && \
    jupyter-kernelspec install cling-cpp17 && \
    jupyter-kernelspec install cling-cpp14 && \
    jupyter-kernelspec install cling-cpp11

RUN chown -R $NB_USER /home/$NB_USER && \
    rm -rf /home/$NB_USER/.local/share/jupyter

# install java jre for h2o
RUN apt-get install -yq openjdk-8-jre

# Reset user from jupyter/base-notebook
USER $NB_USER

# install jupyter-bash
RUN /opt/conda/bin/pip install --no-cache-dir bash_kernel
RUN /opt/conda/bin/python -m bash_kernel.install

# install h2o
RUN /opt/conda/bin/pip install --no-cache-dir --upgrade h2o && \
    /opt/conda/bin/pip install --no-cache-dir --upgrade pandas

# disable authentication
RUN mkdir -p .jupyter
RUN echo "" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py
