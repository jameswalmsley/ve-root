LAYER:=vulkan
include $(DEFINE_LAYER)

vulkan_GIT_REF?=v1.3.207

vulkan:=$(LSTAMP)/vulkan

$(L) += $(vulkan)

DEB_PACKAGES += libpciaccess-dev

$(call git_clone, vulkan-headers, https://github.com/KhronosGroup/Vulkan-Headers.git, $(vulkan_GIT_REF))
$(call git_clone, vulkan-loader, https://github.com/KhronosGroup/Vulkan-Loader.git, $(vulkan_GIT_REF))

include $(BUILD_LAYER)

$(vulkan):
	mkdir -p $(builddir)/vulkan-headers
	cd $(builddir)/vulkan-headers && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/vulkan-headers $(builddir)/vulkan-headers
	cd $(builddir)/vulkan-headers && ninja
	cd $(builddir)/vulkan-headers && sudo ninja install
	mkdir -p $(builddir)/vulkan-loader
	cd $(builddir)/vulkan-loader && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/vulkan-loader $(builddir)/vulkan-loader
	cd $(builddir)/vulkan-loader && ninja
	cd $(builddir)/vulkan-loader && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/vulkan-headers
	rm -rf $(builddir)/vulkan-loader


