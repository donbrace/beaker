#!/bin/sh
#==============================================================================
# check for max_sectors_kb
#==============================================================================
LOGFILE=/tmp/L
DISKS=""
NUM_DISKS=0
get_disk_list () {
	LOGFILE=$1
        if [ -x /usr/bin/lsscsi ]
	then
        	/usr/bin/lsscsi | grep disk | awk '{ print $NF }'  > /tmp/my_disks
        	while read disk
        	do
			echo "DISK found $disk"
			echo "DISK found $disk" >> $LOGFILE 2>&1
                	DISKS[$NUM_DISKS]="$disk"
			NUM_DISKS=`expr $NUM_DISKS + 1`
        	done < /tmp/my_disks
	
		NUM_DISKS=`expr $NUM_DISKS - 1`
	fi
}

check_max_sectors_kb () {
	LOGFILE=$1
        for inx in `seq 0 $NUM_DISKS`
        do
                echo ${DISKS[$inx]}
                echo ${DISKS[$inx]} >> $LOGFILE 2>&1
		D=${DISKS[$inx]}
                D1=`basename $D`
                cat /sys/block/$D1/queue/max_sectors_kb >> $LOGFILE 2>&1
        done
}

set_max_sectors_kb () {
	LOGFILE=$1
        for inx in `seq 0 $NUM_DISKS`
        do
                echo ${DISKS[$inx]}
                echo ${DISKS[$inx]} >> $LOGFILE 2>&1
		D=${DISKS[$inx]}
                D1=`basename $D`
                cat /sys/block/$D1/queue/max_sectors_kb >> $LOGFILE 2>&1
		echo 64 > /sys/block/$D1/queue/max_sectors_kb
                cat /sys/block/$D1/queue/max_sectors_kb >> $LOGFILE 2>&1
        done
}

run_sg_logs () {
	LOGFILE=$1
        if [ -x /usr/bin/sg_logs ]
	then
        	for inx in `seq 0 $NUM_DISKS`
        	do
                	echo ${DISKS[$inx]}
                	echo ${DISKS[$inx]} >> $LOGFILE 2>&1
			D=${DISKS[$inx]}
                	D1=`basename $D`
                	sg_logs -t $D >> $LOGFILE 2>&1
        	done
	fi
}

echo "Running get_disk_list"
get_disk_list $LOGILE
echo "Running check_max_sectors_kb"
check_max_sectors_kb ${LOGFILE}
echo "Running set_max_sectors_kb"
set_max_sectors_kb ${LOGFILE}
echo "Running check_max_sectors_kb"
check_max_sectors_kb ${LOGFILE}
echo "Running run_sg_logs"
run_sg_logs ${LOGFILE}
echo "Running check_max_sectors_kb"
check_max_sectors_kb ${LOGFILE}

cat $LOGFILE


exit 0
