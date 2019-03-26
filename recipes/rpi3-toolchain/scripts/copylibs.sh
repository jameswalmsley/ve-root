NATIVE_PATH=$1
TARGET_PATH=$2

for lib in $(find ${NATIVE_PATH} -name '*.a*') ; do

	destlib=$(realpath --relative-to ${NATIVE_PATH} $lib)

	cp -v $lib ${TARGET_PATH}/$destlib

done
