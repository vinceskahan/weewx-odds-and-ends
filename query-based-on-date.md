This queries for the first two records in the 9am hour on 12/28/2024

````
select dateTime,datetime(dateTime,'unixepoch','localtime') from archive
          where datetime(dateTime,'unixepoch','localtime') like "2024-12-28 09%" limit 2;

1735405200|2024-12-28 09:00:00
1735405500|2024-12-28 09:05:00
````
