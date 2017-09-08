#!/bin/sh
#==============================================================================
# check for max_sectors_kb
#==============================================================================

DISKS=""
NUM_DISKS=0
get_disk_list () {
        if [ -x /usr/bin/lsscsi ]
	then
        	/usr/bin/lsscsi | grep disk | awk '{ print $NF }'  > /tmp/my_disks
        	while read disk
        	do
			echo "DISK found $disk"
                	DISKS[$NUM_DISKS]="$disk"
			NUM_DISKS=`expr $NUM_DISKS + 1`
        	done < /tmp/my_disks
	
		NUM_DISKS=`expr $NUM_DISKS - 1`
	fi
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
        if [ -x /usr/bin/sg_logs ]
	then
        	for inx in `seq 0 $NUM_DISKS`
        	do
                	echo ${DISKS[$inx]}
			D=${DISKS[$inx]}
                	D1=`basename $D`
                	sg_logs -t $D
        	done
	fi
}

echo "Running get_disk_list"
get_disk_list
echo "Running check_max_sectors_kb"
check_max_sectors_kb
echo "Running set_max_sectors_kb"
set_max_sectors_kb
echo "Running check_max_sectors_kb"
check_max_sectors_kb
echo "Running run_sg_logs"
run_sg_logs
echo "Running check_max_sectors_kb"
check_max_sectors_kb

exit 0
