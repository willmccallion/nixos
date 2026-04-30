{ pkgs, config, lib, ... }:

let
	jdk = pkgs.temurin-bin-25;

	prismlauncher-nvidia = pkgs.symlinkJoin {
		name = "prismlauncher-nvidia";
		paths = [ (pkgs.prismlauncher.override { jdks = [ jdk ]; }) ];
		nativeBuildInputs = [ pkgs.makeWrapper ];
		postBuild = ''
			wrapProgram $out/bin/prismlauncher \
				--set __NV_PRIME_RENDER_OFFLOAD 1 \
				--set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
				--set __GLX_VENDOR_LIBRARY_NAME nvidia \
				--set __VK_LAYER_NV_optimus NVIDIA_only
		'';
	};

	prismCfg = pkgs.writeText "prismlauncher.cfg" ''
		[General]
		ApplicationTheme=system
		JavaPath=${jdk}/bin/java
		JavaVendor=Eclipse Adoptium
		JavaVersion=25
		MinMemAlloc=2048
		MaxMemAlloc=8192
		IgnoreJavaCompatibility=true
		Language=en_US
	'';
in {
	home.packages = [ prismlauncher-nvidia ];

	home.activation.prismlauncherDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
		cfg="${config.home.homeDirectory}/.local/share/PrismLauncher/prismlauncher.cfg"
		if [ ! -e "$cfg" ]; then
			run mkdir -p "$(dirname "$cfg")"
			run install -m 644 ${prismCfg} "$cfg"
		fi
	'';
}
