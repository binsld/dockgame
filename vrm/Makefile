download:
	wget https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-virt-3.21.2-x86_64.iso -O alpine.iso --show-progress

format:
	qemu-img create -f qcow2 qemu-machine.qcow 10G

vminstall:
	qemu-system-x86_64 -hda qemu-machine.qcow -boot a -cdrom alpine.iso -hdb fat:rw:./mnt -m 2048 #-nographic -display curses
