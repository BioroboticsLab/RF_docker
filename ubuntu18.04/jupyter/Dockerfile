FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:cuda-devel-ubuntu18.04

RUN python3.7 -m pip --no-cache-dir install \
        numpy \
        scipy \
        matplotlib \
        pandas \
        jupyterlab

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    mkdir /root/.ssh && \
    chmod 700 /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    apt-get clean

COPY jupyter_notebook_config.py /root/.jupyter/
COPY launch.sh /sbin
COPY sshd_config /etc/ssh/sshd_config


WORKDIR "/root"
ENTRYPOINT [ "/sbin/launch.sh" ]
CMD [ "sshd" ]

EXPOSE 22
EXPOSE 8080
