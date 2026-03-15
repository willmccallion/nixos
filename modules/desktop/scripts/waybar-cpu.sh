#!/usr/bin/env bash
# Waybar custom module: CPU usage with per-core tooltip

# Read initial stats
mapfile -t lines1 < <(@awk@ '/^cpu/ {print}' /proc/stat)
sleep 0.5
mapfile -t lines2 < <(@awk@ '/^cpu/ {print}' /proc/stat)

# Calculate overall usage from first line (cpu total)
read -r _ u1 n1 s1 i1 w1 q1 si1 st1 _ <<< "${lines1[0]}"
read -r _ u2 n2 s2 i2 w2 q2 si2 st2 _ <<< "${lines2[0]}"
t1=$((u1+n1+s1+i1+w1+q1+si1+st1))
t2=$((u2+n2+s2+i2+w2+q2+si2+st2))
dt=$((t2-t1))
di=$((i2-i1))
[ "$dt" -eq 0 ] && dt=1
total=$(( (dt - di) * 100 / dt ))

# Build per-core tooltip
tooltip="CPU Total: ${total}%\n"
tooltip+="──────────────\n"

for i in $(seq 1 $((${#lines2[@]} - 1))); do
	read -r name u1 n1 s1 i1 w1 q1 si1 st1 _ <<< "${lines1[$i]}"
	read -r _    u2 n2 s2 i2 w2 q2 si2 st2 _ <<< "${lines2[$i]}"
	ct1=$((u1+n1+s1+i1+w1+q1+si1+st1))
	ct2=$((u2+n2+s2+i2+w2+q2+si2+st2))
	cdt=$((ct2-ct1))
	cdi=$((i2-i1))
	[ "$cdt" -eq 0 ] && cdt=1
	core_pct=$(( (cdt - cdi) * 100 / cdt ))

	# Simple bar: ████░░░░░░ 45%
	filled=$(( core_pct / 10 ))
	empty=$(( 10 - filled ))
	bar=""
	for _ in $(seq 1 $filled); do bar+="█"; done
	for _ in $(seq 1 $empty); do bar+="░"; done

	core_num=${name#cpu}
	printf -v line "Core %2s  %s %3d%%" "$core_num" "$bar" "$core_pct"
	tooltip+="$line\n"
done

# Escape for JSON
tooltip=$(echo -e "$tooltip" | sed 's/"/\\"/g' | tr '\n' '|' | sed 's/|/\\n/g' | sed 's/\\n$//')

printf '{"text": "󰻠 %d%%", "tooltip": "%s"}\n' "$total" "$tooltip"
