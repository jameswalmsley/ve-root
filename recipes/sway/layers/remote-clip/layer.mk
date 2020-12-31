LAYER:=remote-clip
include $(DEFINE_LAYER)

DEPENDS += wl-clipboard

remote-clip.service:=/etc/systemd/system/remote-clip@.service
remote-clip.socket:=/etc/systemd/system/remote-clip.socket
remote-paste.service:=/etc/systemd/system/remote-paste@.service
remote-paste.socket:=/etc/systemd/system/remote-paste.socket

$(L) += $(remote-clip.service)
$(L) += $(remote-clip.socket)
$(L) += $(remote-paste.service)
$(L) += $(remote-paste.socket)

include $(BUILD_LAYER)


$(remote-clip.service):
	sudo cp $(BASE_remote-clip)/etc/systemd/system/remote-clip@.service $@

$(remote-clip.socket):
	sudo cp $(BASE_remote-clip)/etc/systemd/system/remote-clip.socket $@

$(remote-paste.service):
	sudo cp $(BASE_remote-clip)/etc/systemd/system/remote-paste@.service $@

$(remote-paste.socket):
	sudo cp $(BASE_remote-clip)/etc/systemd/system/remote-paste.socket $@

