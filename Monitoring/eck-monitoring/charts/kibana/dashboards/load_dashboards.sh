#!/bin/bash

#Wait 10 minutes ( 120 * 5 seconds delay ) for elasticsearch GREEN to load dashboards
COUNT=120 

#temp log file
LOG_FILE="/mnt/dashboards/load_dashboard.tmp"

for i in `seq 1 $COUNT`
do
        echo "Attempt no. $i to load dashoards."
        curl -k -Ss  -u elastic:${ELASTIC_PASSWORD}  -X POST 'https://127.0.0.1:5601/api/saved_objects/_import?overwrite=true&createNewCopies=false' -H 'kbn-xsrf: true' --form file=@/mnt/dashboards/charts/kibana/dashboards/dashboards.ndjson > $LOG_FILE
        if [[ `cat $LOG_FILE | awk -F"\"" '{print $2 $4}'` == "successCountsuccess" ]]
        then
                echo "Dashboards have been loaded successfully."
                break
        fi
        sleep 5
done
