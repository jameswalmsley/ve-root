LAYER:=libepoxy
include $(DEFINE_LAYER)

libepoxy_GIT_REF?=1.5.9

libepoxy:=$(LSTAMP)/libepoxy

$(L) += $(libepoxy)

$(call git_clone, libepoxy, https://github.com/anholt/libepoxy.git, $(libepoxy_GIT_REF))

include $(BUILD_LAYER)

$(libepoxy):
	mkdir -p $(builddir)/libepoxy
	cd $(builddir)/libepoxy && meson $(MESON_OPTIONS) $(srcdir)/libepoxy $(builddir)/libepoxy
	cd $(builddir)/libepoxy && ninja
	cd $(builddir)/libepoxy && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/libepoxy && $(SUDO) ninja install && rm -rf $(builddir)/libepoxy/meson-logs/install-log.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libepoxy

