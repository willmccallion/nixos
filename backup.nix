## ── Backups ───────────────────────────────────────────────────────────────────
## Daily btrfs snapshots of /home, sent incrementally to /data/backup.
## Local snapshots on the NVMe are kept to the bare minimum (just the latest,
## needed as the parent for incremental btrfs send). Long-term retention lives
## on /data (2 TB HDD).
{ username, ... }:

{
	# Ownership + snapshot/backup directories.
	# `/data`          → user-owned so `will` can freely read/write the disk.
	# `/data/backup`   → root-owned; received btrbk snapshots are read-only
	#                    subvolumes by design, so the user can browse but not
	#                    modify backup data.
	# `/.snapshots/btrbk` → btrfs subvolume for local send-parent snapshots.
	systemd.tmpfiles.rules = [
		"d /data            0755 ${username} users -"
		"v /.snapshots/btrbk 0755 root root -"
		"d /data/backup     0755 root root -"
	];

	services.btrbk.instances.home = {
		onCalendar = "daily";
		settings = {
			# Local (NVMe): keep only the latest snapshot as the send parent.
			snapshot_preserve_min = "latest";
			snapshot_preserve     = "no";

			# Remote (/data): daily/weekly/monthly retention.
			target_preserve_min = "latest";
			target_preserve     = "7d 4w 3m";

			# Incremental sends only — never fall back to a full re-send.
			stream_compress = "zstd";

			volume."/" = {
				subvolume."home" = {
					snapshot_dir = ".snapshots/btrbk";
				};
				target = "/data/backup";
			};
		};
	};
}
