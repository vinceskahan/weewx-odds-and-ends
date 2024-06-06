#!/bin/bash
#
# weewx backup (originally based on wview)

TODAY=`date +%Y_%m_%d`

TMPDIR="/var/tmp"

ARCHIVE_FILE=vp2.sdb
MEM_FILE=mem.sdb
PA_FILE=purpleair.sdb

# moved 2023-0413 to wee5 pip location
ARCHIVE_DIR=/home/pi/weewx-data/archive

DESTDIR=/home/pi/weewx-backups

if [ ! -f $ARCHIVE_DIR/$ARCHIVE_FILE ]; then
	logger "$0 exiting - srcfile not found"
	exit 1
fi

cd $ARCHIVE_DIR

cp $ARCHIVE_FILE ${TMPDIR}
cp $MEM_FILE     ${TMPDIR}
cp $PA_FILE      ${TMPDIR}

cd "${TMPDIR}"

gzip -c ${MEM_FILE} > $MEM_FILE.$TODAY.gz
mv $MEM_FILE.$TODAY.gz $DESTDIR

gzip -c ${ARCHIVE_FILE} > $ARCHIVE_FILE.$TODAY.gz
mv $ARCHIVE_FILE.$TODAY.gz $DESTDIR

gzip -c ${PA_FILE} > $PA_FILE.$TODAY.gz
mv $PA_FILE.$TODAY.gz $DESTDIR

logger "WEEWX_BACKUP - complete to $DESTDIR"

# we leave it here and grab it manually from another system

rm -f "${TMPDIR}"/$ARCHIVE_FILE.$TODAY.gz 
rm -f "${TMPDIR}"/$ARCHIVE_FILE

rm -f "${TMPDIR}"/$MEM_FILE.$TODAY.gz 
rm -f "${TMPDIR}"/$MEM_FILE

rm -f "${TMPDIR}"/$PA_FILE.$TODAY.gz 
rm -f "${TMPDIR}"/$PA_FILE

