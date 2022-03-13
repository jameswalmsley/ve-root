LAYER:=json-c
include $(DEFINE_LAYER)

json-c_GIT_REF?=master

json-c:=$(LSTAMP)/json-c

$(L) += $(json-c)


$(call git_clone, json-c-headers, https://github.com/json-c/json-c.git, $(json-c_GIT_REF))

include $(BUILD_LAYER)

$(json-c):
	mkdir -p $(builddir)/json-c-headers
	cd $(builddir)/json-c-headers && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/json-c-headers
	cd $(builddir)/json-c-headers && ninja
	cd $(builddir)/json-c-headers && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/json-c-headers && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/json-c



