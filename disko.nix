## ── Disko: declarative disk layout ────────────────────────────────────────────
## Used at install time via `disko-install --flake .#nix`.
## Also imported by the running system so mounts/filesystems are generated from
## this single source of truth (replaces most of hardware-configuration.nix).
##
## Layout:
##   /dev/nvme0n1  (1 TB SSD)
##     p1  1 GiB  vfat ESP          → /boot
##     p2  rest   LUKS "cryptroot"  → btrfs
##                                    @           → /
##                                    @home       → /home
##                                    @nix        → /nix
##                                    @snapshots  → /.snapshots
##   /dev/sda      (2 TB HDD)
##     p1  all    LUKS "cryptdata"  → btrfs
##                                    @data       → /data
{ ... }:

let
	# NVMe: zstd:3 (default) — CPU would become the bottleneck above this.
	ssdBtrfsOpts  = [ "compress=zstd:3" "noatime" ];
	# HDD: zstd:6 — slow disk I/O is the bottleneck, so heavier compression
	# actually speeds things up in wall-clock terms while saving more space.
	hddBtrfsOpts  = [ "compress=zstd:6" "noatime" ];
in
{
	disko.devices.disk = {
		nvme = {
			type = "disk";
			device = "/dev/nvme0n1";
			content = {
				type = "gpt";
				partitions = {
					ESP = {
						size = "1G";
						type = "EF00";
						content = {
							type = "filesystem";
							format = "vfat";
							mountpoint = "/boot";
							mountOptions = [ "fmask=0022" "dmask=0022" ];
						};
					};
					luks = {
						size = "100%";
						content = {
							type = "luks";
							name = "cryptroot";
							settings.allowDiscards = true;
							content = {
								type = "btrfs";
								extraArgs = [ "-L" "nixos" "-f" ];
								subvolumes = {
									"@"          = { mountpoint = "/";            mountOptions = ssdBtrfsOpts; };
									"@home"      = { mountpoint = "/home";        mountOptions = ssdBtrfsOpts; };
									"@nix"       = { mountpoint = "/nix";         mountOptions = ssdBtrfsOpts; };
									"@snapshots" = { mountpoint = "/.snapshots";  mountOptions = ssdBtrfsOpts; };
								};
							};
						};
					};
				};
			};
		};

		data = {
			type = "disk";
			device = "/dev/sda";
			content = {
				type = "gpt";
				partitions.luks = {
					size = "100%";
					content = {
						type = "luks";
						name = "cryptdata";
						settings.allowDiscards = true;
						content = {
							type = "btrfs";
							extraArgs = [ "-L" "data" "-f" ];
							subvolumes = {
								"@data" = { mountpoint = "/data"; mountOptions = hddBtrfsOpts; };
							};
						};
					};
				};
			};
		};
	};
}
