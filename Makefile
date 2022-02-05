obj-m += ws2812.o
obj-m += snd-slice.o

ifeq ($(KERNELRELEASE),)

KVERSION ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVERSION)/build
DESTDIR ?= /
M1 ?= /mnt/mmcblk0p1
DTC ?= dtc
PWD := $(shell pwd)

all: modules overlays

install: modules_install overlays_install

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KDIR) M=$(PWD) INSTALL_MOD_PATH=${DESTDIR} modules_install

overlays:
	${DTC} -@ -I dts -O dtb -o slice.dtbo slice-overlay.dts
	${DTC} -@ -I dts -O dtb -o ws2812.dtbo ws2812-overlay.dts

overlays_install:
	cp slice.dtbo ws2812.dtbo ${M1}/overlays

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f slice.dtbo


endif
