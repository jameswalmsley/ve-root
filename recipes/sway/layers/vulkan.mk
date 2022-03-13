LAYER:=vulkan
include $(DEFINE_LAYER)

vulkan_GIT_REF?=v1.3.207

vulkan:=$(LSTAMP)/vulkan
glslang:=$(LSTAMP)/glslang

$(L) += $(vulkan)
$(L) += $(glslang)

DEPENDS += wayland

$(call git_clone, vulkan-headers, https://github.com/KhronosGroup/Vulkan-Headers.git, $(vulkan_GIT_REF))
$(call git_clone, vulkan-loader, https://github.com/KhronosGroup/Vulkan-Loader.git, $(vulkan_GIT_REF))
$(call git_clone, glslang, https://github.com/KhronosGroup/glslang.git, master)

include $(BUILD_LAYER)

$(vulkan):
	mkdir -p $(builddir)/vulkan-headers
	cd $(builddir)/vulkan-headers && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/vulkan-headers
	cd $(builddir)/vulkan-headers && ninja
	cd $(builddir)/vulkan-headers && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/vulkan-headers && $(SUDO) ninja install && rm $(builddir)/vulkan-headers/install_manifest.txt
	mkdir -p $(builddir)/vulkan-loader
	cd $(builddir)/vulkan-loader && cmake -GNinja -DBUILD_WSI_XCB_SUPPORT=OFF -DBUILD_WSI_XLIB_SUPPORT=OFF -DCMAKE_BUILD_TYPE=Release $(srcdir)/vulkan-loader
	cd $(builddir)/vulkan-loader && ninja
	cd $(builddir)/vulkan-loader && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/vulkan-loader && $(SUDO) ninja install && rm $(builddir)/vulkan-loader/install_manifest.txt
	$(stamp)

$(glslang):
	mkdir -p $(builddir)/glslang
	cd $(builddir)/glslang && cmake -GNinja -DBUILD_WSI_XCB_SUPPORT=OFF -DBUILD_WSI_XLIB_SUPPORT=OFF -DCMAKE_BUILD_TYPE=Release $(srcdir)/glslang
	cd $(builddir)/glslang && ninja
	cd $(builddir)/glslang && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/glslang && $(SUDO) ninja install && rm $(builddir)/glslang/install_manifest.txt
	$(stamp)

$(glslang): | $(vulkan)

$(L).clean:
	rm -rf $(builddir)/vulkan-headers
	rm -rf $(builddir)/vulkan-loader
	rm -rf $(builddir)/glslang


