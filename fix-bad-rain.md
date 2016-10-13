### Fixing bad rain, in my case adding records for the day when the rain gauge was plugged up, is:

######Get the last 20 records from the archive, for rain info only, most recent first:

    echo "select datetime(dateTime,'unixepoch','localtime'),dateTime,rain,rainRate 
       from archive order by rowid desc limit 20;" | sqlite3 weewx.sdb

From this, get the dateTime value of the most recent one, which is seconds
  since the epoch.  The localtime representation is there to hopefully make this a little easier.

######Set the rain to 0.01 inches for times in-between two times

    echo "update archive set rain=0.01 where dateTime>=1476342000 and dateTime<=1476343000" |
       sqlite3 weewx.sdb
    
######Updating the sum for the day (ignoring rainRate):

    echo "update archive_day_rain set sum=1.07 where dateTime=1476342000;" | 
       sqlite3 weewx.sdb
