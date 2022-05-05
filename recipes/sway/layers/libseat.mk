LAYER:=libseat
include $(DEFINE_LAYER)

libseat_GIT_REF?=0.6.3

libseat:=$(LSTAMP)/libseat

$(L) += $(libseat)

$(call git_clone, libseat, https://git.sr.ht/~kennylevinsen/seatd, $(libseat_GIT_REF))

include $(BUILD_LAYER)

$(libseat):
	mkdir -p $(builddir)/libseat
	cd $(builddir)/libseat && meson $(MESON_OPTIONS) $(srcdir)/libseat $(builddir)/libseat
	cd $(builddir)/libseat && ninja
	cd $(builddir)/libseat && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libseat


