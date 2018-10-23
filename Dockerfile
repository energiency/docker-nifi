FROM       apache/nifi:1.7.1
COPY       set_additional_properties_and_start.sh ${NIFI_HOME}/../scripts
WORKDIR    ${NIFI_HOME}
USER       root
RUN        chmod +x ../scripts/set_additional_properties_and_start.sh
USER       nifi
ENTRYPOINT ["../scripts/set_additional_properties_and_start.sh"]

