# Chrony Docker Image

![clock picture](https://raw.githubusercontent.com/geoffh1977/docker-chrony/master/files/logo.png)

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/geoffh1977/chrony.svg?style=plastic)

## Description
This docker image provides a small chrony (NTP) image which will sync the local hardware clock and provide access to an NTP time service. The image will automatically configure some sane defaults if no environment variables are provided.

## Configuring At Runtime
There are a number of environment variables which can be configured when the container is started in order to change it's default behaviour:
- **CMD_CIDR -** The CIDR that will allow commands to the running chrony daemon. The default value for this is 127/8 (localhost)
- **ALLOW_CIDR -** The CIDR which allows NTP clients to connect and get the time. The default is to not allow external clients. Multiple CIDRs allowed (comma separated).
- **SYNC_RTC -** Sync the realtime clock on the machine/instance the service is running. This is enabled by default.
- **NTP_SERVER -** The NTP server to get the time to set from. The default is pool.ntp.org.

There is also an option to map in a pre-written configuration file to /etc/chrony.conf - if this file exists it will be used and the auto configuration setup will be skipped.

## Running The Container
In order for the chrony service to operate correctly, the following command is required. Access needs to be granted to the SYS-TIME capability. The below command would enable external access to the NTP for other clients to set the time:

`docker run -d --rm --cap-add SYS_TIME -e ALLOW_CIDR=0.0.0.0/0 -p 123:123/udp geoffh1977/chrony`

You can place the container in interactive mode by replacing the "-d" switch with "-it". 

### Getting In Contact ###
If you find any issues with this container or want to recommend some improvements, fell free to get in contact with me or submit pull requests on github.
