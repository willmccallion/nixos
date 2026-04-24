{ ... }:

let
	ssdBtrfsOpts = [ "compress=zstd:3" "noatime" ];
	hddBtrfsOpts = [ "compress=zstd:6" "noatime" ];
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
									"@"          = { mountpoint = "/";           mountOptions = ssdBtrfsOpts; };
									"@home"      = { mountpoint = "/home";       mountOptions = ssdBtrfsOpts; };
									"@nix"       = { mountpoint = "/nix";        mountOptions = ssdBtrfsOpts; };
									"@snapshots" = { mountpoint = "/.snapshots"; mountOptions = ssdBtrfsOpts; };
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
