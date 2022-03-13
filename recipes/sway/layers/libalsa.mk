LAYER:=libalsa
include $(DEFINE_LAYER)

libalsa_GIT_REF?=master

libalsa:=$(LSTAMP)/libalsa

$(L) += $(libalsa)

$(call git_clone, libalsa, https://github.com/alsa-project/alsa-lib.git, $(libalsa_GIT_REF))

include $(BUILD_LAYER)

$(libalsa):
	rm -rf $(builddir)/libalsa
	cp -r $(srcdir)/libalsa $(builddir)
	cd $(builddir)/libalsa && ./gitcompile --prefix=/usr/local
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libalsa


