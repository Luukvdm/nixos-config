BASE_RK1_TARGET=.\#nixosConfigurations.turing-rk1-base.config.system.build.sdImage
UBOOT_RK1_TARGET = .\#packages.aarch64-linux.uboot-turing-rk1

.PHONY: images
images: image-base image-uboot

.PHONY: image-base build-base copy-base
image-base: build-base copy-base
build-base:
	nix build $(BASE_RK1_TARGET)
copy-base:
	rm -f nixos.img
	cp result/sd-image/nixos-image-sd-card-*-aarch64-linux.img.zst nixos.img.zst
	unzstd --rm nixos.img.zst

.PHONY: image-uboot build-uboot copy-uboot
image-uboot: build-uboot copy-uboot
build-uboot:
	nix build $(UBOOT_RK1_TARGET)
copy-uboot:
	rm -f uboot.img
	cp result/sd-image/uboot.img uboot.img
