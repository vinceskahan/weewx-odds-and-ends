#!/bin/bash
#
# weewx backup (originally based on wview)
#
# this backs up your sqlite3 database(s) safely by working
# off a saved copy of each.  You will need to do a little
# light editing below to set your filenames and directories
# you want to work in.  It's up to you to periodically prune
# old saved copies as well as stashing the .gz files to a
# different computer just-in-case.   FWIW, I rsync the
# ${DESTDIR} below to another computer nightly via cron.
#

#----------- START EDITING HERE ------------------------

# files to back up
FILE_LIST="vp2.sdb mem.sdb purpleair.sdb ecowitt.sdb"

# location of weewx database(s)
ARCHIVE_DIR=/home/pi/weewx-data/archive

# where to back up to
DESTDIR=/home/pi/weewx-backups

# scratch dir to work in
TMPDIR="/var/tmp"

#------------- STOP EDITING HERE -----------------------

TODAY=`date +%Y_%m_%d`

# processing every file, we:
#    cd to the archive dir and copy to a tmpdir
#    cd to the tmpdir and gzip the copy up
#    move the gzipped copy to the destination dir
#    clean up the temporary unzipped copy

logger "WEEWX_BACKUP - starting"
for f in ${FILE_LIST}
do
  cd ${ARCHIVE_DIR}
  if [ -f ${f} ]
  then
     logger "WEEWX_BACKUP - backing up ${f}"

     cp ${f} ${TMPDIR}
     cd ${TMPDIR}

     gzip -c ${f} > ${f}.${TODAY}.gz

     mv ${f}.${TODAY}.gz ${DESTDIR}

     rm -f ${TMPDIR}/${f}
  else
     logger -m "WEEWX_BACKUP - cannot find db file ${ARCHIVE_DIR}/${f}"
  fi
done

logger "WEEWX_BACKUP - complete to $DESTDIR"

