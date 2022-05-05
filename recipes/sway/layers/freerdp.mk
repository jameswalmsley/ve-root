LAYER:=freerdp
include $(DEFINE_LAYER)

bdir:=$(LAYER)

freerdp:=$(LSTAMP)/$(bdir)

$(L) += $(freerdp)

$(call git_clone, $(bdir), https://github.com/FreeRDP/FreeRDP.git, 2.0.0-rc4)

include $(BUILD_LAYER)

$(freerdp): bdir:=$(bdir)
$(freerdp):
	rm -rf $(builddir)/$(bdir)
	mkdir -p $(builddir)/$(bdir)
	cd $(builddir)/$(bdir) && cmake -DCMAKE_BUILD_TYPE=Release -GNinja $(srcdir)/freerdp
	$(stamp)

