LAYER:=ffmpeg
include $(DEFINE_LAYER)

ffmpeg_GIT_REF?=master

ffmpeg:=$(LSTAMP)/ffmpeg

$(L) += $(ffmpeg)

DEB_PACKAGES += yasm

$(call git_clone, ffmpeg, https://github.com/FFmpeg/FFmpeg.git, $(ffmpeg_GIT_REF))

DEPENDS += libva

include $(BUILD_LAYER)

$(ffmpeg):
	mkdir -p $(builddir)/ffmpeg
	cd $(builddir)/ffmpeg && $(srcdir)/ffmpeg/configure --enable-shared --prefix=$(SYSROOT)/usr/local
	cd $(builddir)/ffmpeg && $(MAKE)
	cd $(builddir)/ffmpeg && $(SUDO) $(MAKE) install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/ffmpeg




