Simple Nagios Plugin to check Nest Temp is within a certain range and that it has checked in with in two hours

sample command ./check_nest2.sh <devid_id> ambient_temperature_f
1. Create Nest Developer Account
https://console.developers.nest.com/products
2. Create OAuth Cliet
3. Use Authorization URL to key pin code
4. Get the Authorization token
https://api.home.nest.com/oauth2/access_token?code={pincode}&client_id={your client id}&client_secret={your client secret}&grant_type=authorization_code
5. Get Device ID in the output of this curl
/usr/bin/curl  --location-trusted -H "Content-Type: application/json" -H "Authorization: Bearer <auhtorization toke>" -X GET
  https://developer-api.nest.com/devices/thermostats | sed -e 's/[{}]/''/g' |      awk -v k="text" '{n=split($0,a,","); for
  (i=1; i<=n; i++) print a[i]}'
    ***Authorization token from step 4***
