#! /usr/bin/env bash

[[ -f /etc/profile.d/x11-sudo-askpass.sh ]]  && source /etc/profile.d/x11-sudo-askpass.sh

HEALTH_MAX_GOVERNOR=80
HEALTH_MIN_GOVERNOR=70
FULLCHARGE_MAX_GOVERNOR=100
FULLCHARGE_MIN_GOVERNOR=0

BAT0_DIR="/sys/class/power_supply/BAT1"

CHARGE_START_CTRL="${BAT0_DIR}/charge_control_start_threshold"
CHARGE_END_CTRL="${BAT0_DIR}/charge_control_end_threshold"

read currentMaxCharge <${CHARGE_END_CTRL}
read chargeCycles <${BAT0_DIR}/cycle_count
read e_full <${BAT0_DIR}/energy_full
read e_full_design <${BAT0_DIR}/energy_full_design

health_percent=$(((100 * ${e_full})/${e_full_design}))
[[ $(((100 * ${e_full})%${e_full_design})) -ne 0 ]] && ((health_percent++))

TYPE="full-charge"
CLASS="chargefull"
PERCENTAGE=${currentMaxCharge}

if [[ "${1}" == "toggle" ]]; then
	if [[ "${currentMaxCharge}" == "${HEALTH_MAX_GOVERNOR}" ]]; then
		echo ${FULLCHARGE_MAX_GOVERNOR} | sudo -A tee ${CHARGE_END_CTRL}
		echo ${FULLCHARGE_MIN_GOVERNOR} | sudo -A tee ${CHARGE_START_CTRL}
		PERCENTAGE=${FULLCHARGE_MAX_GOVERNOR}
	else
		echo ${HEALTH_MAX_GOVERNOR} | sudo -A tee ${CHARGE_END_CTRL}
		echo ${HEALTH_MIN_GOVERNOR} | sudo -A tee ${CHARGE_START_CTRL}
		TYPE="health-charge"
		CLASS="chargehealth"
		PERCENTAGE=${HEALTH_MAX_GOVERNOR}
	fi
fi

if [[ "${currentMaxCharge}" == "${HEALTH_MAX_GOVERNOR}" ]]; then
	TYPE="health-charge"
	CLASS="chargehealth"
fi


echo -e "{\"text\": \"${TYPE}, health: $chargeCycles, ${health_percent}%\", \"class\": \"$CLASS\", \"percentage\": ${PERCENTAGE}}"
