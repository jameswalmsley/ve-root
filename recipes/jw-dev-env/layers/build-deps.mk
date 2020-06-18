#
# Helper utils for installing deb packages.
#

.PHONY: deb-info
deb-info:
	@echo "$(DEB_PACKAGES)"

.PHONY: deb-install
deb-install:
	apt -y install $(DEB_PACKAGES)


.PHONY: packages.install
packages.install:
