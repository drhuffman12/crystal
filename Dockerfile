FROM crystallang/crystal

WORKDIR /opt/crystal-head

ENV CMAKE_BUILD_TYPE=Release
ENV CRYSTAL_CONFIG_VERSION HEAD
ENV CRYSTAL_CONFIG_PATH lib:/opt/crystal-head/src:/opt/crystal-head/libs
ENV LIBRARY_PATH /opt/crystal/embedded/lib

ARG LLVM_TARGET_VER
ENV LLVM_TARGET_VER_DEFAULT=3.8
ENV LLVM_TARGET_VER=${LLVM_TARGET_VER:-LLVM_TARGET_VER_DEFAULT}

ENV CC=clang-${LLVM_TARGET_VER}
ENV PATH /opt/crystal-head/bin:/usr/lib/llvm-${LLVM_TARGET_VER}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && add-apt-repository 'deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main' && \
    apt-get install -y --no-install-recommends apt-utils libreadline6 libreadline6-dev build-essential curl \
        libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git \
        llvm-${LLVM_TARGET_VER} llvm-${LLVM_TARGET_VER}-dev clang-${LLVM_TARGET_VER} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /opt/crystal-head

RUN make clean crystal release=1 no_debug=1 progress=1
RUN mkdir -p .release/llvm-${LLVM_TARGET_VER} && cp .build/crystal .release/llvm-${LLVM_TARGET_VER}/crystal

RUN .build/crystal -v

# RUN make crystal spec release=1 no_debug=1 progress=1
# RUN make spec release=1
# RUN .build/crystal spec --release --no-debug
# RUN .build/crystal build spec --release --no-debug
# RUN bin/crystal spec --release --no-debug
# RUN mkdir -p .release/llvm-${LLVM_TARGET_VER} && cp .build/spec .release/llvm-${LLVM_TARGET_VER}/spec
