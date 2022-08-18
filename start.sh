# exit when any command fails
set -e

echo "creating stunnel config file"
config_file="/stunnel/stunnel.conf"
gomplate --file /stunnel/stunnel.conf.gomplate --out ${config_file}
echo "created stunnel config file at ${config_file}"
cat ${config_file}
echo "starting stunnel as a foreground process"
stunnel /stunnel/stunnel.conf
