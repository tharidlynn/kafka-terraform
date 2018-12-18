#!/usr/bin/env bash
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html

# format EBS volume
if [ `file -s ${device_name} | cut -d ' ' -f 2` = 'data' ]; then
    mkfs -t ext4 ${device_name}
fi

# create the mount point
if [ ! -d ${mount_point} ]; then
    mkdir -p ${mount_point}
fi

# mount the volume
if ! grep ${device_name} /etc/mtab > /dev/null; then
    mount ${device_name} ${mount_point}
fi

# mount this EBS volume on every system reboot, add an entry for the device to the /etc/fstab file.
if ! grep ${mount_point} /etc/fstab > /dev/null; then
    echo "${device_name} ${mount_point} ext4 defaults,nofail 0 2" >> /etc/fstab
fi