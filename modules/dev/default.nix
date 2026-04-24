## ── Development ───────────────────────────────────────────────────────────────
## Comment out any import below to disable that language/toolchain.
{ ... }:

{
	imports = [
		./common.nix  # Git, debuggers, build tools
		./rust.nix    # Rust toolchain
		./c.nix       # C/C++ toolchain
		./kernel.nix  # Linux kernel build deps
		./zig.nix     # Zig language
		./python.nix  # Python
	];
}
