LAYER:=libfuse
include $(DEFINE_LAYER)

libfuse_GIT_REF?=master

libfuse:=$(LSTAMP)/libfuse

$(L) += $(libfuse)

$(call git_clone, libfuse, https://github.com/libfuse/libfuse.git, $(libfuse_GIT_REF))

include $(BUILD_LAYER)

$(libfuse):
	mkdir -p $(builddir)/libfuse
	cd $(builddir)/libfuse && meson $(srcdir)/libfuse $(builddir)/libfuse $(MESON_OPTIONS) -Dexamples=false -Dtests=false
	cd $(builddir)/libfuse && ninja
	cd $(builddir)/libfuse && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/libfuse && $(SUDO) ninja install && rm -rf $(builddir)/libfuse/meson-logs/install-log.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libfuse



