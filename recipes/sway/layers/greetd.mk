LAYER:=greetd
include $(DEFINE_LAYER)

GREETD_GIT_REF?=master

greetd:=$(LSTAMP)/greetd

$(L) += $(greetd)

$(call git_clone, greetd, https://git.sr.ht/~kennylevinsen/greetd, $(GREETD_GIT_REF))

include $(BUILD_LAYER)

$(greetd):
	rsync -az --delete $(srcdir)/ $(builddir)
	cd $(builddir)/greetd && cargo build --release
	-sudo mv /usr/local/bin/greetd /usr/local/bin/greetd.old
	sudo cp $(builddir)/greetd/target/release/greetd /usr/local/bin/
	sudo cp $(builddir)/greetd/target/release/agreety /usr/local/bin/
	-sudo useradd -M -G video greeter
	sudo cp $(builddir)/greetd/greetd.service /etc/systemd/system/greetd.service
	-sudo mkdir /etc/greetd
	$(stamp)

