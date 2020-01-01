#
# Helper utils for installing deb packages.
#

deb-info:
	@echo "$(DEB_PACKAGES)"

deb-install:
	apt -y install $(DEB_PACKAGES)

