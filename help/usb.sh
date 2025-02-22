//show see usb info
udevadm info -a -n /dev/video2 | grep -E "ATTR{index}|ATTR{name}|ID_PATH|KERNEL"

//set config
sudo nano /etc/udev/rules.d/99-northstar.rules
SUBSYSTEM=="video4linux", KERNELS=="2-1:1.0", ATTR{index}=="1", SYMLINK+="northstar1"