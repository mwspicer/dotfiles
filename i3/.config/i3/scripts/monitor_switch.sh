#!/bin/bash
#
# monitor-switch - switch outputs using xrand
#
#    Copyright (C) 2012 Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. See <http://www.gnu.org/licenses/gpl.html>

declare -A monitor_opts
declare -a monitors

myname="${0##*/}"
verbose=0

# Read settings from config file
config=${XDG_CONFIG_HOME:-"$HOME"/.config}/"$myname".conf
if [[ -f "$config" ]]; then
	source "$config"
fi

print_monitors() {
	while read -r output conn hex; do
		#echo "# $output	$conn	$(xxd -r -p <<<"$hex")"
		echo "# $output	$conn"
	done < <(xrandr --prop | awk '
	!/^[ \t]/ {
		if (output && hex) print output, conn, hex
		output=$1
		hex=""
	}
	/ConnectorType:/ {conn=$2}
	/[:.]/ && h {
		sub(/.*000000fc00/, "", hex)
		hex = substr(hex, 0, 26) "0a"
		sub(/0a.*/, "", hex)
		h=0
	}
	h {sub(/[ \t]+/, ""); hex = hex $0}
	/EDID.*:/ {h=1}')
}

# if there's no pre-defined monitors list, read from xrandr
# and save them to config file
if [[ -z "$monitors" ]]; then
	while read -r output ; do
		monitors+=("$output")
	done < <(xrandr | awk '$2 ~/^c/{print $1}' | sort)
	cat > "$config" <<-EOF
		# $myname config file

		# List of monitors, from left to right. Edit to your actual layout
		monitors=(${monitors[@]})

		# Extra xrandr options for each monitor.
		# Useful when EDID data does not reflect actual preferred mode
		# Options for non-existing outputs (such as the examples below) are ignored
		# Examples:
		monitor_opts[DFPx]="--mode 1920x1080 --rate 60"
		monitor_opts[DFPy]="--mode 1280x720"

		# As a reference, these were the connected monitors when this config file was created
		# use it as a guide when editing the above monitors list and extra options
		$(print_monitors)

		# For an updated list, run $myname --list
	EOF
fi

message() { printf "%s\n" "$1" >&2 ; }
fatal()   { [[ "$1" ]] && message "$myname: error: $1" ; exit ${2:-1} ; }
argerr()  { printf "%s: %s\n" "$myname" "${1:-error}" >&2 ; usage 1 ; }
invalid() { argerr "invalid argument: $1" ; }
missing() { argerr "missing ${2:+$2 }operand${1:+ from $1}." ; }

usage() {
	cat <<-USAGE
	Usage: $myname [options]
	USAGE
	if [[ "$1" ]] ; then
		cat >&2 <<- USAGE
		Try '$myname --help' for more information.
		USAGE
		exit 1
	fi
	cat <<-USAGE

	Switch monitors using xrandr.

	Options:
	  -h|--help          - show this page.
	  -v|--verbose       - print in terminal the full xrandr command executed.

	  -l|--list          - list connector and monitor names of connected outputs

	  -a|--all           - enable all monitors.
	  -s|--select OUTPUT - enable monitor OUTPUT, disable all others.
	  -l|--left          - enable leftmost monitor.  Alias for --select ${monitors[0]}
	  -r|--right         - enable rightmost monitor. Alias for --select ${monitors[${#monitors[@]}-1]}

	Copyright (C) 2012 Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>
	License: GPLv3 or later. See <http://www.gnu.org/licenses/gpl.html>
	USAGE
	exit 0
}

# Option handling
for arg in "$@"; do [[ "$arg" == "-h" || "$arg" == "--help" ]] && usage ; done
while (( $# )); do
	case "$1" in
	-v|--verbose) verbose=1 ;;
	-q|--no-notify) notify=0 ;;
	-l|--list) list=1 ;;
	-a|--all) all=1 ;;
	-s|--select) shift ; monitor="$1" ;;
	-l|--left ) monitor="${monitors[0]}" ;;
	-r|--right) monitor="${monitors[${#monitors[@]}-1]}" ;;
	*) invalid "$1" ;;
	esac
	shift
done

if ((list)); then
	echo "Connected monitors:"
	print_monitors
	exit
fi

if [[ -z "$monitor" && -z "$all" ]]; then
	usage
fi

# Loop outputs (monitors)
for output in "${monitors[@]}"; do
	if ((all)) || [[ "$output" = "$monitor" ]]; then
		xrandropts+=(--output "$output" --auto ${monitor_opts["$output"]})
		if ((all)); then
			if [[ "$output" = "${monitors[0]}" ]]; then
				xrandropts+=(--pos 0x0 --primary)
			else
				xrandropts+=(--right-of "$previous")
			fi
			previous="$output"
		else
			xrandropts+=(--primary)
		fi
	else
		xrandropts+=(--output "$output" --off)
	fi
done

((verbose)) && message "$myname: executing xrandr ${xrandropts[*]}"
xrandr "${xrandropts[@]}"

