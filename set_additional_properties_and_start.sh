#!/bin/sh

if [ ! -z "$JAVA_HEAP_SIZE" ]; then
  echo "Using ${JAVA_HEAP_SIZE} of memory for the Nifi Java process"
  sed -i "s/Xms.*m/Xms$JAVA_HEAP_SIZE/g" ${NIFI_HOME}/conf/bootstrap.conf
  sed -i "s/Xmx.*m/Xmx$JAVA_HEAP_SIZE/g" ${NIFI_HOME}/conf/bootstrap.conf
else
  echo "Using default memory settings for the Nifi Java process"
fi

trap "echo Received trapped signal, beginning shutdown...;" KILL TERM HUP INT EXIT;

../scripts/start.sh &
wait
