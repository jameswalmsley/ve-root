LAYER:=package
include $(DEFINE_LAYER)

package:=$(OUT)/sway-$(SWAY_GIT_REF)-$(DISTRO_FULL).tar.gz

$(L) += $(package)

DEB_PACKAGES += pigz

include $(BUILD_LAYER)

$(package):
	mkdir -p $(builddir)/package
	cd $(BASE) && tar cvf - -C $(SYSROOT) . | pigz -c -9 > $@
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/package

