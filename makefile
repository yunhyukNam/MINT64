all:BootLoader Disk.img

BootLoader:
	@echo
	@echo ============== Build Boot Loader ===============
	@echo

	make -C 00.BootLoader/Source
 	
	@echo
	@echo =============== Build Complete ===============
	@echo

Disk.img:00.BootLoader/BootLoader.bin
	
	@echo
	@echo =========== Disk Image Build Start ===========
	@echo
	
	cp 00.BootLoader/Source/BootLoader.bin Disk.img
	
	@echo
	@echo ============= All Build Complete =============
	@echo

clean:
	make -C 00.BootLoader/Source clean
	rm -f Disk.img