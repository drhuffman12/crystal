FROM crystallang/crystal

# ENV LLVM_TARGET_VER=3.8

ENV CC=clang-3.8
ENV CMAKE_BUILD_TYPE=Release
ENV CRYSTAL_CONFIG_VERSION HEAD
ENV CRYSTAL_CONFIG_PATH lib:/opt/crystal-head/src:/opt/crystal-head/libs
ENV LIBRARY_PATH /opt/crystal/embedded/lib
ENV PATH /opt/crystal-head/bin:/usr/lib/llvm-3.8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

RUN apt-get update && \
    apt-get install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git \
      llvm-3.8-dev clang-3.8 libreadline6 libreadline6-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/crystal-head

ADD . /opt/crystal-head

RUN make clean crystal release=1
