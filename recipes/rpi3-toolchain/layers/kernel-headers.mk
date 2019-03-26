LAYER:=kernel-headers
include $(DEFINE_LAYER)

kernel-headers:=$(TC_STAMP)/kernel-headers

$(L) += $(kernel-headers)

DEPENDS += gcc-bootstrap
RUNAFTER += gcc-bootstrap

$(call git_clone, linux, https://github.com/raspberrypi/linux.git, rpi-4.19.y)

include $(BUILD_LAYER)

$(kernel-headers):
ifneq ($(TC_NATIVE),y)
	-ln -s $(TC_NATIVEDIR)/bin/$(TC_TARGET)-gcc $(TC_PREFIX)/bin/$(TC_TARGET)-gcc
endif
	cd $(srcdir)/linux && $(MAKE) ARCH=$(TC_ARCH) CROSS_COMPILE=$(TC_PREFIX)/bin/$(TC_TARGET)- INSTALL_HDR_PATH=$(TC_SYSROOT) headers_install
ifneq ($(TC_NATIVE),y)
	rm $(TC_PREFIX)/bin/$(TC_TARGET)-gcc
endif
	$(stamp)
