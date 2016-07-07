FROM mongo
WORKDIR /root
ADD https://github.com/s3tools/s3cmd/releases/download/v1.6.1/s3cmd-1.6.1.tar.gz /root/
RUN tar xf s3cmd-1.6.1.tar.gz && \
    cd s3cmd-1.6.1 && \
    apt-get -qq update && \
    apt-get -qq install -y cron python python-setuptools && \
    python setup.py install && \
    cd .. && \
    rm -rf s3cmd-1.6.1* && \
    apt-get clean
WORKDIR /
ADD ./scripts/ /scripts/
ENTRYPOINT [ "/scripts/start.sh" ]
