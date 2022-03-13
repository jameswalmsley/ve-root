LAYER:=libinih
include $(DEFINE_LAYER)

libinih_GIT_REF?=r53

libinih:=$(LSTAMP)/libinih

$(L) += $(libinih)

$(call git_clone, libinih, https://github.com/benhoyt/inih.git, $(libinih_GIT_REF))

include $(BUILD_LAYER)

$(libinih):
	mkdir -p $(builddir)/libinih
	cd $(builddir)/libinih && meson $(MESON_OPTIONS) $(srcdir)/libinih $(builddir)/libinih
	cd $(builddir)/libinih && ninja
	cd $(builddir)/libinih && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/libinih && $(SUDO) ninja install && rm -rf $(builddir)/libinih/meson-logs/install-log.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libinih

