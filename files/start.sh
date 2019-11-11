#!/bin/sh

# Set The Variables
CMD_CIDR=${CMD_CIDR:-"127/8"}
NTP_SERVER=${NTP_SERVER:-"pool.ntp.org"}
SYNC_RTC=${SYNC_CLOCK:-"true"}
ALLOW_CIDR=${ALLOW_CIDR:-""}

CONFIG=${CONFIG:-"/etc/chrony.conf"}

# Setup Files
mkdir /etc/chrony
touch /var/lib/chrony/chrony.drift && \
chown chrony:chrony -R /var/lib/chrony

# Write The Config File
cat << EOF > "${CONFIG}"
cmdallow ${CMD_CIDR}
pool ${NTP_SERVER} iburst
initstepslew 10 ${NTP_SERVER}
driftfile /var/lib/chrony/chrony.drift
local stratum 10
makestep 1.0 3
EOF

if [ "${SYNC_RTC}" = "true" ] ; then echo "rtcsync" >> "${CONFIG}" ; fi
if [ "${ALLOW_CIDR}" != "" ] ; then echo "allow ${ALLOW_CIDR}" >> "${CONFIG}" ; fi

chronyd -d -s -f "${CONFIG}"