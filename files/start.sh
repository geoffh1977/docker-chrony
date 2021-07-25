#!/bin/sh

# Set The Variables
CMD_CIDR=${CMD_CIDR:-"127/8"}
NTP_SERVER=${NTP_SERVER:-"pool.ntp.org"}
SYNC_RTC=${SYNC_CLOCK:-"true"}
ALLOW_CIDR=${ALLOW_CIDR:-""}

CONFIG=${CONFIG:-"/etc/chrony.conf"}

# Setup Drift File
touch /var/lib/chrony/chrony.drift && \
chown chrony:chrony -R /var/lib/chrony

# Write New Config File If None Mapped In
echo
if [ -f "${CONFIG}" ]
then
  echo "Reading Mapping In Config File!"
else
  echo "Writing New Config File"
  mkdir /etc/chrony
  cat << EOF > "${CONFIG}"
cmdallow ${CMD_CIDR}
pool ${NTP_SERVER} iburst
initstepslew 10 ${NTP_SERVER}
driftfile /var/lib/chrony/chrony.drift
local stratum 10
makestep 1.0 3
EOF
  if [ "${SYNC_RTC}" = "true" ] ; then echo "rtcsync" >> "${CONFIG}" ; fi
  if [ "${ALLOW_CIDR}" != "" ] ; then
      echo "${ALLOW_CIDR}" | tr ',' '\n' | while read CIDR; do echo "allow ${CIDR}"; done >> "${CONFIG}"
  fi
fi
echo

# Run Chrony Daemon
chronyd -d -s -f "${CONFIG}"
