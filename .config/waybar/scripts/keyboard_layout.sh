#! /usr/bin/env bash

INTERNAL_KBD_ID="1:1:AT_Translated_Set_2_keyboard"

function getCurrentLayout(){

	swaymsg -t get_inputs --raw |\
		jq -r '.[]
			| select(.identifier == "'"${INTERNAL_KBD_ID}"'")
			| .xkb_active_layout_name
			| gsub("(.*\\(|\\))"; ""; "s")'
}


case "${1}" in
	next)
		swaymsg input ${INTERNAL_KBD_ID} xkb_switch_layout next;;
esac

echo -n '{"text":"'"$(getCurrentLayout)"'", "tooltip":"Current layout of built in keyboard", "class":"custom-kbdlayout"}'
