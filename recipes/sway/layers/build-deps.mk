#
# Helper utils for installing deb packages.
#

.PHONY: deb-info
deb-info:
	@echo "$(DEB_PACKAGES)"

.PHONY: deb-install
deb-install:
	DEBIAN_FRONTEND=noninteractive apt-get -y install $(DEB_PACKAGES)

.PHONY: deb-run-info
deb-run-info:
	@echo "$(DEB_RUN_PACKAGES)"

.PHONY: deb-run-install
deb-run-install:
	DEBIAN_FRONTEND=noninteractive apt-get -y install $(DEB_RUN_PACKAGES)

.PHONY: pip-info
pip-info:
	@echo "$(PIP_PACKAGES)"

.PHONY: pip-install
pip-install:
	pip3 install $(PIP_PACKAGES)
