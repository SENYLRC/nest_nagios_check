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
#Authorization token from step 4

Auth="<auhtorization token"
#Specify the low and high temps
LowTemp="53"
HighTemp="95"

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
  echo "Missing parameters!"
  echo "Usage: ./check_nest.sh device_id paramter"
  exit 2
fi
#Get Current room temp
status=$(curl  --location-trusted -H "Content-Type: application/json" -H "Authorization: Bearer $Auth"  https://developer-api.nest.com/devices/thermostats/$1"/"$2)
#Get the last time nest checked in
lastconnection=$(curl  --location-trusted -H "Content-Type: application/json" -H "Authorization: Bearer $Auth"  https://developer-api.nest.com/devices/thermostats/$1/last_connection)

#Get time from two hours ago
curtime=$(date -u "+%Y-%m-%d %H:%M:%S")
#Reformat the nest timestamp
nesttime1=${lastconnection/T/ }
nesttime=${nesttime1:1:${#string}-6}

curepoch=$(date "--date=$curtime" +%s)
nestepoch=$(date "--date=$nesttime" +%s)
DIFFSEC=`expr ${curepoch} - ${nestepoch}`
ping -c 1 developer-api.nest.com > /dev/null
if  [ $? -eq 0 ]; then
  if [ $DIFFSEC -lt 3660 ]
  then
    if [ $status -ge $LowTemp ] && [ $status -le $HighTemp ]
    then
      echo "Temp OK $status"
      exit 0
  elif [ $status -lt $LowTemp ]
    then
      echo "Temp might be too cold: $status"
      exit 2
  elif [ $status -gt $HighTemp ]
    then
      echo "Temp might be too hot: $status"
      exit 2
    else
      echo "Temp error"
      exit 2
    fi
  else
    echo "Nest Offline for over two hours"
    exit 2
  fi
else
  echo "NEST API Offline"
  exit 0
fi
