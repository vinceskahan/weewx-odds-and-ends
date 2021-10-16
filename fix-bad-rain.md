## Fixing bad rain, in my case adding records for the day when the rain gauge was plugged up, is:

### Clean up the archive table

#### Get the last 20 records from the archive, for rain info only, most recent first:

    echo "select datetime(dateTime,'unixepoch','localtime'),dateTime,rain,rainRate 
       from archive order by rowid desc limit 20;" | sqlite3 weewx.sdb

From this, get the dateTime value of the most recent one, which is seconds
  since the epoch.  The localtime representation is there to hopefully make this a little easier.

Note: this prints in 'newest at the top' reverse order, so be careful in the next step.  See the 'desc(ending)' ?
  To print ascending order change 'desc' above to 'asc'.
  
#### Set the rain to 0.01 inches for times in-between two times

    echo "update archive set rain=0.01 where dateTime<=1476343000 and dateTime>=1476342000;" |
       sqlite3 weewx.sdb

### Clean up the sum for the day

#### Get the last 20 records from the archive_day_rain table, sum only, most recent first

    echo "select datetime(dateTime,'unixepoch','localtime'),dateTime,sum
       from archive_day_rain order by rowid desc limit 20;" | sqlite3 weewx.sdb
   
#### Update the sum for the day (ignoring rainRate):

    echo "update archive_day_rain set sum=1.07 where dateTime=1476342000;" | 
       sqlite3 weewx.sdb
