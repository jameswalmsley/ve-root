#!/bin/bash

CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}👉 $1${CLEAR}\n";
  fi
  echo "Usage: $0 --arch DEB_ARCH --out output_dir --release DEB_RELEASE [options]"
  echo "  -a, --arch            target arch."
  echo "  -r, --release         release (e.g. xenial | jessie)"
  echo "  -o, --out             output dir"
  echo "  -p, --pfile           Package list file"
  echo "  -e, --efile           Package exclude list file"
  echo "  -d, --dfile           Optional development package list"
  echo ""
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -a|--arch) ARCH="$2"; shift;shift;;
  -r|--release) RELEASE="$2";shift;shift;;
  -o|--out) OUTDIR="$2";shift;shift;;
  -p|--pfile) PFILE="$2";shift;shift;;
  -e|--efile) EFILE="$2";shift;shift;;
  -d|--dfile) DFILE="$2";shift;shift;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

if [ -z "$ARCH" ]; then usage "--arch not specified"; fi;
if [ -z "$RELEASE" ]; then usage "--release not specified"; fi;
if [ -z "$OUTDIR" ]; then usage "--out not specified"; fi;

if [ -z "$PFILE" ]; then
PKG_INCLUDE=""
else
PKG_INCLUDE=$(cat $PFILE | xargs |  sed -e 's/ /,/g')
fi

if [ -z "$DFILE" ]; then
echo "No development packages."
else
echo "Including development packages."
PKG_INCLUDE="$PKG_INCLUDE,$(cat $DFILE | xargs | sed -e 's/ /,/g')"
fi

if [ -z "$EFILE" ]; then 
PKG_EXCLUDE=""
else
PKG_EXCLUDE=$(cat $EFILE | xargs | sed -e 's/ /, /g')
fi

mkdir -p $OUTDIR
export ARCH=$ARCH

OPT_INCLUDE=""
OPT_EXCLUDE=""

if [ -z "$PKG_INCLUDE" ]
then
      OPT_INCLUDE=""
else
      OPT_INCLUDE="--include=$PKG_INCLUDE"
fi

if [ -z "$PKG_EXCLUDE" ]
then
      OPT_EXCLUDE=""
else
      OPT_EXCLUDE="--exclude=$PKG_EXCLUDE"
fi

debootstrap \
	--arch=$ARCH \
	--keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg \
  --verbose \
  --foreign \
  --variant=minbase \
  $OPT_EXCLUDE \
  $OPT_INCLUDE \
  $RELEASE \
  $OUTDIR

cp /usr/bin/qemu-aarch64-static $OUTDIR/usr/bin

# for Gentoo
#pushd  $OUTDIR/usr/bin
#ln -s qemu-aarch64-static qemu-aarch64
#popd

chroot $OUTDIR /bin/bash -c "DEBIAN_FRONTEND=noninteractive /debootstrap/debootstrap --second-stage"
