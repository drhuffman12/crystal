FROM crystallang/crystal

WORKDIR /opt/crystal-head

ENV CMAKE_BUILD_TYPE=Release
ENV CRYSTAL_CONFIG_VERSION HEAD
ENV CRYSTAL_CONFIG_PATH lib:/opt/crystal-head/src:/opt/crystal-head/libs
ENV LIBRARY_PATH /opt/crystal/embedded/lib

ARG LLVM_TARGET_VER
ENV LLVM_TARGET_VER_DEFAULT=4.0
ENV LLVM_TARGET_VER=${LLVM_TARGET_VER:-LLVM_TARGET_VER_DEFAULT}

ENV CC=clang-${LLVM_TARGET_VER}
ENV PATH /opt/crystal-head/bin:/usr/lib/llvm-${LLVM_TARGET_VER}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils libreadline6 libreadline6-dev build-essential curl \
        libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends llvm-${LLVM_TARGET_VER} llvm-${LLVM_TARGET_VER}-dev clang-${LLVM_TARGET_VER} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl http://crystal-lang.s3.amazonaws.com/llvm/llvm-3.5.0-1-linux-x86_64.tar.gz | tar xz -C /opt

COPY . /opt/crystal-head

RUN make clean crystal release=1 no_debug=1 progress=1
