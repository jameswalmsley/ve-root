LAYER:=meson
include $(DEFINE_LAYER)

meson-tc:=$(OUT)/meson.toolchain

$(L) += $(meson-tc)

include $(BUILD_LAYER)

MESON_BUILD_TYPE?=release

MESON_OPTIONS:=--native-file=$(meson-tc) --buildtype=$(MESON_BUILD_TYPE) $(MESON_OPTIONS)

define meson_impl

$(STAMP)/$$(L)/$(strip $1): $(meson-tc)
$$(L) += $(STAMP)/$(L)/$(strip $1)

$(STAMP)/$$(L)/$(strip $1):
	mkdir -p $$(builddir)/$(strip $(1))
	meson $(MESON_OPTIONS) $(strip $(3)) $(strip $(2)) $$(builddir)/$(strip $(1))
	cd $$(builddir)/$(strip $(1)) && ninja $$(BUILD_JOBS)
	cd $$(builddir)/$(strip $(1)) && $$(SUDO) DESTDIR=$$(SYSROOT) ninja install
	$$(stamp)
endef

define meson_srcdir
	$(eval $(meson_impl))
endef

define meson
	$(call meson_srcdir, $1, $$(srcdir)/$(strip $1))
endef


$(meson-tc): $(BASE_meson)/meson.toolchain.in
	mkdir -p $(SYSROOT)
	cp $(BASE_meson)/meson.toolchain.in $@
	sed -i s:@SYSROOT@:$(SYSROOT): $@
	sed -i s:@PREFIX@:$(PREFIX): $@
	sed -i s:@LIBDIR@:$(LIBDIR): $@

