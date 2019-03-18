FROM ubuntu:18.04
MAINTAINER James Walmsley <james@vitalelement.co.uk>

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install git vim debootstrap qemu-system-arm qemu-efi qemu-user qemu-user-static build-essential bc libncurses-dev multistrap dpkg-dev gcc-aarch64-linux-gnu g++-aarch64-linux-gnu cmake python3 python3-jinja2 python sudo
RUN apt-get -y install rsync cpio gzip u-boot-tools
RUN apt-get -y install android-tools-fsutils
RUN apt-get -y install bash-completion
RUN apt-get -y install device-tree-compiler libssl1.0-dev bison flex swig
RUN apt-get -y install libpython-dev strace
RUN apt-get -y install vim tmux
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install cryptsetup
RUN apt-get -y install squid-deb-proxy
RUN apt-get -y install pv
RUN apt-get -y install pigz
RUN apt-get -y install meson

WORKDIR /root/develop

