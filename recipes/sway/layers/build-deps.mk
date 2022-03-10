#
# Helper utils for installing deb packages.
#

.PHONY: deb-info
deb-info:
	@echo "$(DEB_PACKAGES)"

.PHONY: deb-install
deb-install:
	DEBIAN_FRONTEND=noninteractive apt-get -y install $(DEB_PACKAGES)

.PHONY: pip-info
pip-info:
	@echo "$(PIP_PACKAGES)"

.PHONY: pip-install
pip-install:
	pip3 install $(PIP_PACKAGES)
