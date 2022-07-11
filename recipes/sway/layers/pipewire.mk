LAYER:=pipewire
include $(DEFINE_LAYER)

PIPEWIRE_GIT_REF?=0.3.48

pipewire:=$(LSTAMP)/pipewire

$(L) += $(pipewire)

DEB_PACKAGES += libgirara-dev
DEB_PACKAGES += libgstreamer1.0-dev
DEB_PACKAGES += libasound2-dev
DEB_PACKAGES += libgstreamer-plugins-base1.0-dev
DEB_PACKAGES += libsdl2-dev
DEB_PACKAGES += libva-dev
DEB_PACKAGES += libsbc-dev
DEB_PACKAGES += libsndfile-dev
DEB_PACKAGES += libavahi-client-dev
DEB_PACKAGES += libx11-xcb-dev
DEB_PACKAGES += libcanberra-dev
DEB_PACKAGES += libusb-1.0-0-dev
DEB_PACKAGES += libcap-dev
DEB_PACKAGES += libwebrtc-audio-processing-dev
DEB_PACKAGES += liblilv-dev
DEB_PACKAGES += libinih-dev

DEB_RUN_PACKAGES += liblilv-0-0

$(call git_clone, pipewire, https://gitlab.freedesktop.org/pipewire/pipewire.git, $(PIPEWIRE_GIT_REF))

ifeq ($(CONFIG_LIBALSA),y)
DEPENDS += libalsa
endif

DEPENDS += ffmpeg

include $(BUILD_LAYER)

$(pipewire):
	mkdir -p $(builddir)/pipewire
	cd $(builddir)/pipewire && meson $(srcdir)/pipewire $(builddir)/pipewire $(MESON_OPTIONS)
	cd $(builddir)/pipewire && ninja
	cd $(builddir)/pipewire && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/pipewire

