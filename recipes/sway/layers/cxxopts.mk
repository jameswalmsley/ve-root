LAYER:=cxxopts
include $(DEFINE_LAYER)

CXXOPTS_GIT_REF?=v3.0.0

cxxopts:=$(LSTAMP)/cxxopts

$(L) += $(cxxopts)

$(call git_clone, cxxopts, https://github.com/jarro2783/cxxopts.git, $(CXXOPTS_GIT_REF))

include $(BUILD_LAYER)

$(cxxopts):
	mkdir -p $(builddir)/cxxopts
	cd $(builddir)/cxxopts && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/cxxopts -DCXXOPTS_BUILD_TESTS=OFF -DCXXOPTS_BUILD_EXAMPLES=OFF
	cd $(builddir)/cxxopts && ninja
	cd $(builddir)/cxxopts && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/cxxopts

