# Nixos-config

My NixOS configuration

## Turing-RK1

Inspired by [GiyoMoon](https://github.com/GiyoMoon/nixos-turing-rk1/).

Note that the img files my config builds are considerably larger then GiyoMoons, I havent looked into why this is.

### Building

```shell
# Main image
nix build .#nixosConfigurations.turing-rk1-base.config.system.build.sdImage
cp result/sd-image/* .
# nix shell -p zstd
unzstd nixos-image-sd-card-*-aarch64-linux.img.zst

# Uboot image
nix build .#packages.aarch64-linux.uboot-turing-rk1
cp result/sd-image/* .
```

### Flashing uboot

Flashing the OS image to the external block device is a bit tricky too, as we can't use the BMC of the Turing Pi. We have to either flash it by using a third-party device or we first flash NixOS onto the eMMC, flash the image to the external block device from within the RK1, then wipe the eMMC again with the small image that only contains uboot. I didn't want to open my case again to get the NVMe drives out, so I went with the latter, let's go through the steps:

1. Flash the `nixos.img` image onto the eMMC over the BMC User Interface
2. Power on the node
3. Copy `nixos.img` to the node:

```shell
scp nixos.img luuk@{NODE_IP}:/home/luuk/
```

4. SSH into the node and flash the image on the external block device. I'm flashing it to the NVMe drive under `/dev/nvme0n1`

```shell
sudo dd if=nixos.img of=/dev/nvme0n1 bs=4M status=progress oflag=sync
sudo sync
```

5. Power off the node
6. Flash the `uboot.img` image onto the eMMC over the BMC User Interface

### Deploying

After flashing the image the first time the node will user DHCP.
You can override the hostname in deploy-rs using the `hostname` flag.

```shell
deploy .#worker01 --hostname 192.168.2.2
```
