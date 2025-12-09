FROM ubuntu:24.04

# install dependencies for building and running smolBSD image
RUN apt update           \
&&  apt install -y       \
        build-essential  \
        curl             \
	git              \
	libarchive-tools \
        qemu-system      \
	rsync            \
	mtools		 \
	uuid-runtime

# add scripts and smolBSD image
RUN mkdir -p /data
RUN scripts/create-smolbsd.sh cicd /data/smolBSD
WORKDIR /work
