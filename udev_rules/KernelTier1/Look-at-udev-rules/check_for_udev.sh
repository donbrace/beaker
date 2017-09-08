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
		NUM_DISKS=`expr $NUM_DISKS + 1`
        done < /tmp/my_disks

	NUM_DISKS=`expr $NUM_DISKS - 1`
}

check_max_sectors_kb () {
        for inx in `seq 0 $NUM_DISKS`
        do
                echo ${DISKS[$inx]}
		D=${DISKS[$inx]}
                D1=`basename $D`
                cat /sys/block/$D1/queue/max_sectors_kb
        done
}

set_max_sectors_kb () {
        for inx in `seq 0 $NUM_DISKS`
        do
                echo ${DISKS[$inx]}
		D=${DISKS[$inx]}
                D1=`basename $D`
                cat /sys/block/$D1/queue/max_sectors_kb
		echo 64 > /sys/block/$D1/queue/max_sectors_kb
        done
}

run_sg_logs () {
        [ -x sg_logs ] || return 0
        for inx in `seq 0 $NUM_DISKS`
        do
                echo ${DISKS[$inx]}
		D=${DISKS[$inx]}
                D1=`basename $D`
                sg_logs -t $D
        done
}

get_disk_list
check_max_sectors_kb
set_max_sectors_kb
check_max_sectors_kb
run_sg_logs
check_max_sectors_kb
