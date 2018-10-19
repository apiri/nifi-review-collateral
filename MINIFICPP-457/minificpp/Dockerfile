FROM ubuntu:16.04 AS build

RUN apt-get update && apt-get install -y git sudo

RUN git clone https://github.com/phrocker/nifi-minifi-cpp \
    && cd nifi-minifi-cpp \
    && git pull https://github.com/phrocker/nifi-minifi-cpp MINIFICPP-457 \
    && ./bootstrap.sh -e -t && cd build  && make -j4 VERBOSE=1 package
RUN tar xf /nifi-minifi-cpp/build/nifi-minifi-cpp-0.5.0-bin.tar.gz -C /root/
ENTRYPOINT /root/nifi-minifi-cpp-0.5.0/bin/minifi.sh run
# ENTRYPOINT ["/home/minifi/start.sh"]
#
# # Second stage: the runtime image
# # Edge required for rocksdb
# FROM ubuntu:16.04
#
# RUN apt-get update && apt-get install -y openssl   gcc g++ \
#   bison \
#   flex \
#   patch \
#   autoconf \
#   automake \
#   libtool \
#   libcurl4-openssl-dev \
#   librocksdb-dev librocksdb4.1 \
#   uuid-dev uuid \
#   libboost-all-dev libssl-dev \
#   libbz2-dev liblzma-dev \
#   doxygen libpython-dev
#
# COPY --from=build /nifi-minifi-cpp/build/nifi-minifi-cpp-0.5.0-bin.tar.gz /root/nifi-minifi-cpp-0.5.0-bin.tar.gz
