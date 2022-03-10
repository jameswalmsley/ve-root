LAYER:=cxxopts
include $(DEFINE_LAYER)

CXXOPTS_GIT_REF?=v3.0.0

cxxopts:=$(LSTAMP)/cxxopts

$(L) += $(cxxopts)

$(call git_clone, cxxopts, https://github.com/jarro2783/cxxopts.git, $(CXXOPTS_GIT_REF))

include $(BUILD_LAYER)

$(cxxopts):
	mkdir -p $(builddir)/cxxopts
	cd $(builddir)/cxxopts && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/cxxopts $(builddir)/cxxopts
	cd $(builddir)/cxxopts && ninja
	cd $(builddir)/cxxopts && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/cxxopts && $(SUDO) ninja install && rm $(builddir)/cxxopts/install_manifest.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/cxxopts

