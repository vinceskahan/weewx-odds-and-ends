
### checking weewx db schema

weewx v5 has a new feature that calculates elements referenced in skins/extensions that are not natively in the db schema. This causes high cpu usage and slow cycle time for systems that have databases that use the old wview-compatible (pre-v4) schema.   To check your schema is wview-extended (the default for v4 and later):

````
# wview-extended will return 114 for the following command
echo ".schema" | sqlite3 weewx.sdb | wc -l
````

