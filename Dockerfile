# Pull base image.
FROM centos:7
# Sourced from https://github.com/deepstreamIO/deepstream.io-docker 

MAINTAINER Rohit Hazra <rohithzr@live.com>

RUN yum install -y wget && \ 
    wget https://bintray.com/deepstreamio/rpm/rpm -O /etc/yum.repos.d/bintray-deepstreamio-rpm.repo && \ 
    yum install -y deepstream.io-2.1.3-1

# Installing Plugins
RUN deepstream install storage mongodb && \
    deepstream install cache redis && \
    deepstream install msg redis

# Expose ports

# HTTP Port
EXPOSE 6020

COPY ./config/config.yml /etc/deepstream/config.yml
COPY ./config/users.yml /etc/deepstream/users.yml

# LIST OF ENV VARIABLES SUPPORTED

ENV DEEPSTREAM_PORT="6020" \
    DEEPSTREAM_HOST="0.0.0.0" \
    REDIS_MSG_HOST="127.0.0.1" \
    REDIS_MSG_PORT="6379" \
    REDIS_CACHE_HOST="127.0.0.1" \
    REDIS_CACHE_PORT="6379"" \
    MONGODB_CONNECTION_STRING="mongodb://user:pass@host:port" \
    MONGODB_DATABASE="deepstream" \
    MONGODB_COLLECTION="deepstream-records" \
    MONGODB_SPLIT_CHAR="/" \
    DEEPSTREAM_PASSWORD="RGZG5Sz1Vs++MsNfGaWULaPboKTvTNdqxKFPlAnoSOQ=2dj6ms28tuAzVTbUaFhsNg=="
   # DEEPSTREAM_PASS_PLAIN "p@123"

# TODO : generate password based on plain password

# ENV DEEPSTREAM_PASSWORD=$(sed -e 's#.*: \(\)#\1#' <<< $(deepstream hash $(echo $DEEPSTREAM_PASS_PLAIN)))

# Define default command.
CMD [ "deepstream", "start" ]