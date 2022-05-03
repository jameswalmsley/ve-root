ECHO:=echo


ifeq ($(OS),Windows_NT)
	WINDOWS:=y
else
UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	MACOS:=y
	NPROC:=$(shell sysctl -n hw.physicalcpu)
	ECHO:=gecho
else
	NPROC:=$(shell nproc)
endif
endif

