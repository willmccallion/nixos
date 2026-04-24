## ── Backups ───────────────────────────────────────────────────────────────────
## Daily btrfs snapshots of /home, sent incrementally to /data/backup.
## Local snapshots on the NVMe are kept to the bare minimum (just the latest,
## needed as the parent for incremental btrfs send). Long-term retention lives
## on /data (2 TB HDD).
{ ... }:

{
	# Ensure snapshot source + receive target exist before btrbk runs.
	# `v` creates a btrfs subvolume (required for /.snapshots/btrbk to hold
	# per-subvolume snapshots); `d` is a regular directory.
	systemd.tmpfiles.rules = [
		"v /.snapshots/btrbk 0755 root root -"
		"d /data/backup      0755 root root -"
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
