## ── Fish Functions ────────────────────────────────────────────────────────────
## Custom fish shell functions for fuzzy finding, project navigation,
## tmux management, and general utilities.
## Remove this import from shell/default.nix to disable all custom functions.
{ pkgs, ... }:

{
	programs.fish.functions = {

		# ── Project / Navigation ───────────────────────────────────────────

		# Fuzzy jump to a project directory and start a dev tmux session
		pj = ''
			set dir (fd --type d --max-depth 1 . ~/projects | fzf --height 40%)
			test -z "$dir" && return
			cd "$dir" && dev
		'';

		# Go up N directories (default: 1)
		up = ''
			set -l count 1
			test (count $argv) -gt 0 && set count $argv[1]
			set -l path ""
			for i in (seq $count)
				set path "$path../"
			end
			cd $path
		'';

		# Fuzzy cd with tree preview
		fcd = ''
			set dir (fd --type d --hidden --exclude .git | fzf --preview "tree -C -L 2 {}")
			test -n "$dir" && cd "$dir"
		'';

		# ── File Search / Edit ─────────────────────────────────────────────

		# Fuzzy find file and open in nvim
		vf = ''
			set file (fd --type f --hidden --exclude .git | fzf --preview "bat --color=always --line-range :500 {}")
			test -n "$file" && nvim "$file"
		'';

		# Interactive file content search with ripgrep + fzf → open in nvim
		fif = ''
			set match (fzf --ansi --disabled \
				--bind "change:reload:rg --color=always --line-number --no-heading -- {q} || true" \
				--delimiter ':' \
				--preview "test -n {1} && bat --color=always --highlight-line {2} {1}" \
				--preview-window '+{2}/2')
			test -z "$match" && return
			set file (echo $match | cut -d':' -f1)
			set line (echo $match | cut -d':' -f2)
			nvim "+$line" "$file"
		'';

		# View images (icat via SSH, imv locally)
		view = ''
			test (count $argv) -eq 0 && echo "Usage: view <image>" && return 1
			if set -q SSH_CLIENT; or set -q SSH_TTY
				kitten icat "$argv[1]"
			else
				imv "$argv[1]" &
			end
		'';

		# ── Git ────────────────────────────────────────────────────────────

		# Interactive git add via fzf with diff preview
		ig = ''
			set files (git status --short | fzf --multi --preview "git diff --color=always {2}" | awk '{print $2}')
			test (count $files) -gt 0 && git add $files
		'';

		# Fuzzy git log with diff preview
		fgl = ''
			set commit (git log --oneline --decorate --color=always \
				| fzf --ansi --preview "git show --color=always {1}" \
				| awk '{print $1}')
			test -n "$commit" && git show "$commit"
		'';

		# ── Tmux ───────────────────────────────────────────────────────────

		# Create a 4-window tmux dev session (code, term, ai, util)
		dev = ''
			set -l name $argv[1]
			test -z "$name" && set name (basename (pwd))
			set name (string replace -a '.' '_' $name)

			if tmux has-session -t "$name" 2>/dev/null
				tmux attach-session -t "$name"
				return
			end

			tmux new-session -d -s "$name" -n code
			tmux send-keys -t "$name:code" "vf" Enter
			tmux new-window -t "$name" -n term
			tmux new-window -t "$name" -n ai
			tmux send-keys -t "$name:ai" "claude" Enter
			tmux new-window -t "$name" -n util
			tmux select-window -t "$name:code"
			tmux attach-session -t "$name"
		'';

		# Fuzzy switch between tmux sessions
		ts = ''
			set session (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --height 40%)
			test -z "$session" && return
			if set -q TMUX
				tmux switch-client -t "$session"
			else
				tmux attach-session -t "$session"
			end
		'';

		# Fuzzy kill tmux sessions (multi-select with TAB)
		tk = ''
			set sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --multi --height 40%)
			for s in $sessions
				tmux kill-session -t "$s"
				echo -e "\e[32mKilled: $s\e[0m"
			end
		'';

		# ── Clipboard ──────────────────────────────────────────────────────

		# Copy all file contents in current directory to clipboard
		fcopy = ''
			find . -type f -not -path './.git/*' | sort | while read -l f
				echo "=== $f ==="
				command cat "$f"
				echo ""
			end | copy
		'';

		# Copy file tree structure to clipboard
		tcopy = ''
			tree | copy
		'';

		# ── Archives ───────────────────────────────────────────────────────

		# Extract common archive formats
		ex = ''
			test (count $argv) -eq 0 && echo "Usage: ex <file>" && return 1
			if not test -f "$argv[1]"
				echo "'$argv[1]' is not a valid file"
				return 1
			end
			switch $argv[1]
				case '*.tar.bz2'; tar xjf $argv[1]
				case '*.tar.gz';  tar xzf $argv[1]
				case '*.bz2';     bunzip2 $argv[1]
				case '*.rar';     unrar x $argv[1]
				case '*.gz';      gunzip $argv[1]
				case '*.tar';     tar xf $argv[1]
				case '*.tbz2';    tar xjf $argv[1]
				case '*.tgz';     tar xzf $argv[1]
				case '*.zip';     unzip $argv[1]
				case '*.Z';       uncompress $argv[1]
				case '*.7z';      7z x $argv[1]
				case '*';         echo "'$argv[1]' cannot be extracted"
			end
		'';

		# ── Cleanup ────────────────────────────────────────────────────────

		# Scan ~/projects for heavy build directories and offer to delete
		sweep = ''
			echo "Scanning ~/projects for build artifacts..."
			set dirs (fd -t d -H "^(target|node_modules)\$" ~/projects)
			if test (count $dirs) -eq 0
				echo "Nothing to clean."
				return
			end
			for d in $dirs
				echo "  $d"
			end
			echo ""
			read -P "Delete all? [y/N] " confirm
			if test "$confirm" = "y"
				for d in $dirs
					rm -rf "$d"
					echo -e "\e[32mDeleted: $d\e[0m"
				end
			end
		'';

		# ── History ────────────────────────────────────────────────────────

		# Fuzzy search command history
		h = ''
			set cmd (history | fzf --no-sort --exact --height 40%)
			test -n "$cmd" && commandline -r "$cmd"
		'';

		# ── Notes ──────────────────────────────────────────────────────────

		# Create and manage markdown notes in ~/.notes
		note = ''
			set notes_dir "$HOME/.notes"
			mkdir -p "$notes_dir"

			if test (count $argv) -eq 0
				# Browse existing notes
				set file (fd --type f --extension md . "$notes_dir" \
					| fzf --preview "bat --color=always {}")
				test -n "$file" && nvim "$file"
			else
				# Create new note
				set title (string join " " $argv)
				set slug (echo "$title" | string lower | string replace -ar '[^a-z0-9]+' '-' | string trim --chars='-')
				set date (date +%Y-%m-%d)
				set filepath "$notes_dir/$slug.md"

				echo "---" > "$filepath"
				echo "title: $title" >> "$filepath"
				echo "date: $date" >> "$filepath"
				echo "tags: []" >> "$filepath"
				echo "---" >> "$filepath"
				echo "" >> "$filepath"
				echo "## Context" >> "$filepath"
				echo "" >> "$filepath"
				echo "## Technical Details" >> "$filepath"
				echo "" >> "$filepath"
				echo "## Next Steps" >> "$filepath"

				nvim "$filepath"
			end
		'';

		# ── Python ─────────────────────────────────────────────────────────

		# Toggle Python virtual environment
		venv = ''
			if set -q VIRTUAL_ENV
				deactivate
				return
			end
			if test -d .venv
				source .venv/bin/activate.fish
			else if test -d venv
				source venv/bin/activate.fish
			else
				echo "No .venv or venv found"
			end
		'';
	};
}
