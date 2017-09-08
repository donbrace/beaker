#!/bin/sh
#==============================================================================
# check for max_sectors_kb
#==============================================================================

DISKS=""
NUM_DISKS=0
get_disk_list () {
        [ -x /usr/bin/lsscsi ] || return 0
        /usr/bin/lsscsi | grep disk | awk '{ print $NF }'  > /tmp/my_disks
        while read disk
        do
                DISKS[$NUM_DISKS]="$disk"
        done < /tmp/my_disks
}

get_disk_list

