#!/bin/bash

mkdir -p /mnt/ilm
LOG_FILE="/mnt/ilm/load_ilm.tmp"

#Loading ILMs

declare -A ilm_policies=(
    ["business-ilm"]="/usr/share/logstash-beats/ilm/business-ilm.json"
    ["technical-ilm"]="/usr/share/logstash-beats/ilm/technical-ilm.json"
    ["logstash-monitoring-ilm"]="/usr/share/logstash-mon/ilm/logstash-monitoring-ilm.json"
    ["metricbeat-ilm"]="/usr/share/metricbeat/ilm/metricbeat-ilm.json"
    ["filebeat-ilm"]="/usr/share/filebeat/ilm/filebeat-ilm.json"
    ["heartbeat-ilm"]="/usr/share/heartbeat/ilm/heartbeat-ilm.json"
    ["metricbeat-hpa-ilm"]="/usr/share/metricbeat/ilm/metricbeat-hpa-ilm.json"
    ["traces-apm.traces-default_policy"]="/usr/share/apm-server/ilm/traces-apm.traces-default_policy.json"
    ["metrics-apm.app_metrics-default_policy"]="/usr/share/apm-server/ilm/metrics-apm.app_metrics-default_policy.json"
)


echo "Starting loading logstash beats ILMs objects..."
for x in "${!ilm_policies[@]}"
do
    file_path="${ilm_policies[$x]}"
    i=1
    echo "Starting loading ILM: $x"
    while :
    do
        echo "Attempt no. $i to load ILM"
        curl -k -Ss  -u elastic:${ELASTIC_PASSWORD}  -X PUT  https://${RELEASE_NAME}-elasticsearch-es-http:9200/_ilm/policy/$x  -H 'Content-Type: application/json' -H 'kbn-xsrf: true' -d @"$file_path" > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "acknowledged" ]
        then
                echo "ILM $x has been loaded successfully."
                break
        fi
        i=`expr $i + 1`
        sleep 5
    done
done

#Loading templates
echo "Starting loading templates..."
for x in business-template technical-template metricbeat-hpa-template filebeat-monitoring-template metricbeat-template
do
    i=1
    echo "Starting template $x"
    while :
    do
        echo "Attempt no. $i to load template"
        curl -k -Ss  -u elastic:${ELASTIC_PASSWORD}  -X PUT  https://${RELEASE_NAME}-elasticsearch-es-http:9200/_index_template/$x  -H 'Content-Type: application/json' -H 'kbn-xsrf: true' -d @/mnt/templates/$x-log.json > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "acknowledged" ]
        then
                echo "Teamplte $x has been loaded successfully."
                break
        fi
        i=`expr $i + 1`
        sleep 5
    done
done



echo "Executing rollover for metricbeat data stream..."
i=1
while :
do
    echo "Attempt no. $i to rollover data stream"
    echo -n "Checking if metricbeat-ilm policy exists ... "
    /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XGET https://${RELEASE_NAME}-elasticsearch-es-http:9200/_ilm/policy/metricbeat-ilm > $LOG_FILE
    if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "metricbeat-ilm" ]
    then
        echo "yes"
        /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XPOST https://${RELEASE_NAME}-elasticsearch-es-http:9200/metricbeat-${STACK_VERSION}/_rollover > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [[ `cat $LOG_FILE | awk -F"\"" '{print $2}'` == "acknowledged" ]]
        then
                echo "Data stream metricbeat has been rollovered successfully."
                break
        fi
        echo "Rollover not acknowledged, retrying..."
    else
        echo "no"
    fi
    i=`expr $i + 1`
    sleep 5

done


echo "Executing rollover for filebeat data stream..."
i=1
while :
do
    echo "Attempt no. $i to rollover data stream"
    echo -n "Checking if filebeat-ilm policy exists ... "
    /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XGET https://${RELEASE_NAME}-elasticsearch-es-http:9200/_ilm/policy/filebeat-ilm > $LOG_FILE
    if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "filebeat-ilm" ]
    then
        echo "yes"
        /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XPOST https://${RELEASE_NAME}-elasticsearch-es-http:9200/filebeat-${STACK_VERSION}/_rollover > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [[ `cat $LOG_FILE | awk -F"\"" '{print $2}'` == "acknowledged" ]]
        then
                echo "Data stream filebeat has been rollovered successfully."
                break
        fi
        echo "Rollover not acknowledged, retrying..."
    else
        echo "no"
    fi
    i=`expr $i + 1`
    sleep 5
done

echo "Executing rollover for heartbeat data stream..."
i=1
while :
do
    echo "Attempt no. $i to rollover data stream"
    echo -n "Checking if heartbeat-ilm policy exists ... "
    /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XGET https://${RELEASE_NAME}-elasticsearch-es-http:9200/_ilm/policy/heartbeat-ilm > $LOG_FILE
    if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "heartbeat-ilm" ]
    then
        echo "yes"
        /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XPOST https://${RELEASE_NAME}-elasticsearch-es-http:9200/heartbeat-${STACK_VERSION}/_rollover > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [[ `cat $LOG_FILE | awk -F"\"" '{print $2}'` == "acknowledged" ]]
        then
                echo "Data stream heartbeat has been rollovered successfully."
                break
        fi
        echo "Rollover not acknowledged, retrying..."
    else
        echo "no"
    fi
    i=`expr $i + 1`
    sleep 5
done



#Load and rollover apm policies
echo "Starting rolling over apm data streams..."


for y in traces-apm-default
do
    i=1
    echo "Executing rollover for traces data stream $y..."
    echo "Checking if data stream $y exists..."
    /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XGET https://${RELEASE_NAME}-elasticsearch-es-http:9200/_data_stream/$y > $LOG_FILE
    if ! grep -q "\"name\" : \"$y\"" "$LOG_FILE"; then
        echo "Data stream $y does not exist. Skipping rollover and exiting loop."
        break
    fi
    while :
    do
        echo "Attempt no. $i to rollover data stream"
        /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XPOST https://${RELEASE_NAME}-elasticsearch-es-http:9200/$y/_rollover > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "acknowledged" ]
        then
            echo "Data stream $y has been rollovered successfully."
            break
        fi
        echo "Rollover not acknowledged, retrying..."
        i=`expr $i + 1`
        sleep 5
    done
done

echo "Fetching metrics-apm.app data streams..."
curl -k -Ss -u elastic:${ELASTIC_PASSWORD} -XGET https://${RELEASE_NAME}-elasticsearch-es-http:9200/_data_stream/metrics-apm.app* > $LOG_FILE

DATA_STREAMS=$(grep -o '"name"\s*:\s*"metrics-apm.app[^"]*"' "$LOG_FILE" \
| awk -F'"' '{print $4}')

if [ -z "$DATA_STREAMS" ]; then
echo "No metrics-apm.app data streams found. Exiting."
exit 0
fi

for y in $DATA_STREAMS
do
    i=1
    echo "Executing rollover for data stream $y..."
    while :
    do
        echo "Attempt no. $i to rollover data stream"
        /usr/bin/curl -Ss -k -u elastic:${ELASTIC_PASSWORD} -XPOST https://${RELEASE_NAME}-elasticsearch-es-http:9200/$y/_rollover > $LOG_FILE
        echo "Response:"
        cat $LOG_FILE
        echo -e "\n--------"
        if [ "`cat $LOG_FILE | awk -F\"\\\"\" '{print $2}'`" = "acknowledged" ]
        then
            echo "Data stream $y has been rollovered successfully."
            break
        fi
        echo "Rollover not acknowledged, retrying..."
        i=`expr $i + 1`
        sleep 5
    done
done




