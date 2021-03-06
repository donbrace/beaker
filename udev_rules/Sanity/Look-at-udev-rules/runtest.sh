#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /distribution/dbrace/Sanity/look-at-udev-rules
#   Description: Look at udev rules
#   Author: Don Brace <dbrace@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2017 Red Hat, Inc.
#
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation, either version 2 of
#   the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE.  See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses/.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/bin/rhts-environment.sh || exit 1
. /usr/share/beakerlib/beakerlib.sh || exit 1

PACKAGE="dbrace"

rlJournalStart
    rlPhaseStartSetup
        rlAssertRpm $PACKAGE
        rlRun "TmpDir=\$(mktemp -d)" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "touch foo" 0 "Creating the foo test file"
        rlAssertExists "foo"
        rlRun "ls -l foo" 0 "Listing the foo test file"
        rlRun "cat /etc/*-release" 0 "Looking at release file"
        rlRun "uname -r" 0 "uname"
        rlRun "ls -l /usr/lib/udev/rules.d" 0 "Listing the udev rules directory"
        rlRun "[ -f /usr/lib/udev/rules.d/60-block.rules ] && cat /usr/lib/udev/rules.d/60-block.rules" 0 "cat out 60-block.rules"
        rlRun "[ -f /usr/lib/udev/rules.d/60-persistent-storage.rules ] && cat /usr/lib/udev/rules.d/60-persistent-storage.rules" 0 "cat out 60-persistent-storage.rules"
        rlRun "which lsscsi" 0 "Where is lsscsi"
        rlRun "[ -x /usr/bin/lsscsi ] && lsscsi" 0 "list of SCSI devices"
        rlRun "which sg_logs" 0 "Where is sg_logs"
        rlRun "pwd" 0 "Where am I?"
        rlRun "ls -l" 0 "What file are where I am"
        rlRun "ls -l /mnt/tests/kernel/udev_rules/Sanity/Look-at-udev-rules" 0 "What file are /mnt"
        rlRun "ls -l $TmpDir" 0 "What file are in $TmpDir"
        rlRun "[ -x /mnt/tests/kernel/udev_rules/Sanity/Look-at-udev-rules/check_for_udev.sh ] && /mnt/tests/kernel/udev_rules/Sanity/Look-at-udev-rules/check_for_udev.sh >> /tmp/DON 2>&1; cat /tmp/DON" 0 "test max_sectors_kb"
    rlPhaseEnd

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
