LAYER:=libportal
include $(DEFINE_LAYER)

libportal_GIT_REF?=main

libportal:=$(LSTAMP)/libportal

$(L) += $(libportal)

$(call git_clone, libportal, https://github.com/flatpak/libportal.git, $(libportal_GIT_REF))

ifeq ($(CONFIG_GLIB),y)
DEPENDS += glib
endif

ifeq ($(CONFIG_LIBGEOCLUE),y)
DEPENDS += libgeoclue
endif

include $(BUILD_LAYER)

$(libportal):
	mkdir -p $(builddir)/libportal
	cd $(builddir)/libportal && meson $(srcdir)/libportal $(builddir)/libportal $(MESON_OPTIONS) -Ddocs=false -Dtests=false -Dbackends=gtk3
	cd $(builddir)/libportal && ninja
	cd $(builddir)/libportal && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libportal
