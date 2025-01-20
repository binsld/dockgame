if [ -e qemu-machine.qcow ] 
then
	qemu-system-x86_64 -hda qemu-machine.qcow  -hdb fat:rw:./mnt -m 2048 -nographic -display curses
else
	echo "File qemu-machine.qcow does not exist. Please run make"
fi
