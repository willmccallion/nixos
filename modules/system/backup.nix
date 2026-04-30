{ username, ... }:

{
	systemd.tmpfiles.rules = [
		"d /data             0755 ${username} users -"
		"v /.snapshots/btrbk 0755 root root -"
		"d /data/backup      0755 root root -"
	];

	services.btrfs.autoScrub = {
		enable = true;
		interval = "monthly";
	};

	services.btrbk.instances.home = {
		onCalendar = "daily";
		settings = {
			snapshot_preserve_min = "latest";
			snapshot_preserve     = "no";
			target_preserve_min   = "latest";
			target_preserve       = "7d 4w 3m";
			stream_compress       = "zstd";

			volume."/" = {
				subvolume."home" = {
					snapshot_dir = ".snapshots/btrbk";
				};
				target = "/data/backup";
			};
		};
	};
}
