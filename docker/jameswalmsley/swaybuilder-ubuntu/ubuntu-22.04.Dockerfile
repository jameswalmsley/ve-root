FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
    
RUN apt-get update && apt-get -y install \
    autoconf \
    bison \
    byacc \
    check \
    clang-12 \
    cmake \
    flex \
    gir1.2-poppler-0.18 \
    git \
    gobject-introspection \
    intltool \
    libasound2-dev \
    libavahi-client-dev \
    libavdevice-dev \
    libboost-program-options-dev \
    libcairo2-dev \
    libcanberra-dev \
    libcap-dev \
    libclang-12-dev \
    libclc-dev \
    libcmocka-dev \
    libdbusmenu-gtk3-dev \
    libdrm-dev \
    libelf-dev \
    libepoxy-dev \
    libffi-dev \
    libfmt-dev \
    libfreeimage-dev \
    libgbm-dev \
    libgdk-pixbuf2.0-dev \
    libgeoclue-2-dev \
    libgirara-dev \
    libgirepository1.0-dev \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libgles2-mesa-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer1.0-dev \
    libgtk-3-dev \
    libgtkmm-3.0-dev \
    libinih-dev \
    libiniparser-dev \
    libinput-dev \
    libjpeg-dev \
    libjson-c-dev \
    libjson-glib-dev \
    libjsoncpp-dev \
    liblilv-dev \
    liblz4-dev \
    libmd-dev \
    libmpdclient-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libomp-12-dev \
    libpam0g-dev \
    libpango1.0-dev \
    libpciaccess-dev \
    libpixman-1-dev \
    libpoppler-dev \
    libpoppler-glib-dev \
    libpoppler-glib8 \
    libpulse-dev \
    libsbc-dev \
    libsdl2-dev \
    libsensors4-dev \
    libsigc++-2.0-dev \
    libsndfile-dev \
    libswscale-dev \
    libsystemd-dev \
    libtiff-dev \
    libtool \
    libudev-dev \
    libusb-1.0-0-dev \
    libva-dev \
    libvdpau-dev \
    libwebrtc-audio-processing-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-composite0-dev \
    libxcb-dri2-0-dev \
    libxcb-dri3-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-present-dev \
    libxcb-res0-dev \
    libxcb-shm0-dev \
    libxcb-xinput-dev \
    libxcursor-dev \
    libxext-dev \
    libxfixes-dev \
    libxfont-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxkbfile-dev \
    libxrandr-dev \
    libxshmfence-dev \
    libxxf86vm-dev \
    libzstd-dev \
    llvm-12 \
    mesa-common-dev \
    mupdf \
    nettle-dev \
    pavucontrol \
    pigz \
    pkg-config \
    poppler-data \
    sudo \
    unzip \
    valac \
    x11proto-core-dev \
    x11proto-fonts-dev \
    x11proto-present-dev \
    x11proto-randr-dev \
    x11proto-record-dev \
    x11proto-render-dev \
    x11proto-scrnsaver-dev \
    x11proto-video-dev \
    x11proto-xf86dri-dev \
    x11proto-xinerama-dev \
    xfonts-utils \
    xtrans-dev \
    yasm \
    xutils-dev \
    && apt-get -y clean


