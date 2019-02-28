#!/bin/bash
#
#sample command ./check_nest2.sh <devid_id> ambient_temperature_f
#1. Create Nest Developer Account
#https://console.developers.nest.com/products
#2. Create OAuth Cliet
#3. Use Authorization URL to key pin code
#4. Get the Authorization token
#https://api.home.nest.com/oauth2/access_token?code={pincode}&client_id={your client id}&client_secret={your client secret}&grant_type=authorization_code
#Get devie_id by doing this command
# /usr/bin/curl  --location-trusted -H "Content-Type: application/json" -H "Authorization: Bearer <auhtorization toke>" -X GET https://developer-api.nest.com/devices/thermostats | sed -e 's/[{}]/''/g' |      awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'

Auth="<auhtorization token"

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
 echo "Missing parameters!"
 echo "Usage: ./check_nest.sh device_id paramter"
 exit 2
fi

status=$(curl  --location-trusted -H "Content-Type: application/json" -H "Authorization: Bearer $Auth"  https://developer-api.nest.com/devices/thermostats/$1"/"$2)

if [ $status -ge 50 ] && [ $status -le 100 ]
then
 echo "Temp OK"
 exit 0
elif [ $status -lt 50 ]
 then
  echo "Temp to low"
  exit 2
elif [ $status -gt 100 ]
  then
   echo "Temp to high"
   exit 2
else
 echo "Temp error"
 exit 2
fi
