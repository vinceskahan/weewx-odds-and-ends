
This is a known good config file for mosquitto MQTT
since it comes up so often on weewx-user.

ref: https://projects.eclipse.org/projects/iot.mosquitto/releases/2.0


````
#-----------------------------------------------------------
### this is an anonymous listener on the usual port
#
# listener 1883
# allow_anonymous true
#
#-----------------------------------------------------------
### this is a simple username/password pair
#
# remember to make a password file entry for the user
#     mosquitto_passwd -c /etc/mosquitto/pwfile myuser
#     (and enter the mosquitto password for that user twice)
#
# to subscribe - remember to provide the user and pass you created
# ala:
#    mosquitto_sub -t mytopic -h myaddress -u myuser -P mypass
#
listener 1883
allow_anonymous false
password_file /etc/mosquitto/pwfile
#
#-----------------------------------------------------------
````

