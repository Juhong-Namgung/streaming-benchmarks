#!/usr/bin/env bash

TEST_TIME=1800

CLEAN_RESULT_CMD="cd stream-benchmarking; rm data/*.txt;"

LOAD_START_CMD="cd stream-benchmarking; ./stream-bench.sh START_LOAD;"
LOAD_STOP_CMD="cd stream-benchmarking; ./stream-bench.sh STOP_LOAD;"

DELETE_TOPIC="cd stream-benchmarking/kafka_2.11-0.11.0.2; ./bin/kafka-topics.sh --delete --zookeeper zookeeper-node01:2181,zookeeper-node02:2181,zookeeper-node03:2181 --topic ad-events;"
CREATE_TOPIC="cd stream-benchmarking/kafka_2.11-0.11.0.2; ./bin/kafka-topics.sh --create --zookeeper zookeeper-node01:2181,zookeeper-node02:2181,zookeeper-node03:2181 --replication-factor 1 --partitions 4 --topic ad-events;"


START_FLINK_CMD="cd stream-benchmarking; ./flink-1.4.0/bin/start-cluster.sh;"
STOP_FLINK_CMD="cd stream-benchmarking; ./flink-1.4.0/bin/stop-cluster.sh;"
START_FLINK_PROC_CMD="cd stream-benchmarking; ./stream-bench.sh START_FLINK_PROCESSING;"
STOP_FLINK_PROC_CMD="cd stream-benchmarking; ./stream-bench.sh STOP_FLINK_PROCESSING;"

START_SPARK_MASTER_CMD="cd stream-benchmarking/spark-2.2.1-bin-hadoop2.6; ./sbin/start-master.sh -h stream-node01 -p 7077;"
STOP_SPARK_MASTER_CMD="cd stream-benchmarking/spark-2.2.1-bin-hadoop2.6; ./sbin/stop-master.sh;"
START_SPARK_SLAVE_CMD="cd stream-benchmarking/spark-2.2.1-bin-hadoop2.6; ./sbin/start-slave.sh spark://stream-node01:7077;"
STOP_SPARK_SLAVE_CMD="cd stream-benchmarking/spark-2.2.1-bin-hadoop2.6; ./sbin/stop-slave.sh;"
START_SPARK_PROC_CMD="cd stream-benchmarking; ./stream-bench.sh START_SPARK_PROCESSING;"
STOP_SPARK_PROC_CMD="cd stream-benchmarking; ./stream-bench.sh STOP_SPARK_PROCESSING;"

START_ZK_CMD="cd stream-benchmarking/kafka_2.11-0.11.0.2; ./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties"
STOP_ZK_CMD="cd stream-benchmarking/kafka_2.11-0.11.0.2; ./bin/zookeeper-server-stop.sh;"

START_KAFKA_CMD="cd stream-benchmarking/kafka_2.11-0.11.0.2; ./bin/kafka-server-start.sh -daemon config/server.properties"
STOP_KAFKA_CMD="cd stream-benchmarking/kafka_2.11-0.11.0.2; ./bin/kafka-server-stop.sh;"

START_REDIS_CMD="cd stream-benchmarking; ./stream-bench.sh START_REDIS;"
STOP_REDIS_CMD="cd stream-benchmarking; ./stream-bench.sh STOP_REDIS;"

function stopLoadData {
    echo "Main loader stopping node 01"
    nohup ssh ubuntu@load-node01 ${LOAD_STOP_CMD} &
    echo "Main loader stopping node 02"
    nohup ssh ubuntu@load-node02 ${LOAD_STOP_CMD} &
    echo "Main loader stopping node 03"
    nohup ssh ubuntu@load-node03 ${LOAD_STOP_CMD} &
}

function stopZkLoadData {
    echo "Zookeeper loader stopping node 01"
    nohup ssh ubuntu@zookeeper-node01 ${LOAD_STOP_CMD} &
    echo "Zookeeper loader stopping node 02"
    nohup ssh ubuntu@zookeeper-node02 ${LOAD_STOP_CMD} &
    echo "Zookeeper loader stopping node 03"
    nohup ssh ubuntu@zookeeper-node03 ${LOAD_STOP_CMD} &
}


function startLoadData {
    echo "Main loader starting node 01"
    nohup ssh ubuntu@load-node01 ${LOAD_START_CMD} &
    echo "Main loader starting node 02"
    nohup ssh ubuntu@load-node02 ${LOAD_START_CMD} &
    echo "Main loader starting node 03"
    nohup ssh ubuntu@load-node03 ${LOAD_START_CMD} &

}

function startZkLoadData {
    echo "Zookeeper loader starting node 01"
    nohup ssh ubuntu@zookeeper-node01 ${LOAD_START_CMD} &
    echo "Zookeeper loader starting node 02"
    nohup ssh ubuntu@zookeeper-node02 ${LOAD_START_CMD} &
    echo "Zookeeper loader starting node 03"
    nohup ssh ubuntu@zookeeper-node03 ${LOAD_START_CMD} &
}


function cleanKafka {
    echo "Deleted kafka topic"
    ssh ubuntu@redis ${DELETE_TOPIC}
    echo "Created kafka topic"
    ssh ubuntu@redis ${CREATE_TOPIC}
}

function startZK {
    echo "Starting Zookeeper node 01"
    ssh ubuntu@zookeeper-node01 ${START_ZK_CMD}
    echo "Starting Zookeeper node 02"
    ssh ubuntu@zookeeper-node02 ${START_ZK_CMD}
    echo "Starting Zookeeper node 03"
    ssh ubuntu@zookeeper-node03 ${START_ZK_CMD}
}

function stopZK {
    echo "Stopping Zookeeper node 01"
    ssh ubuntu@zookeeper-node01 ${STOP_ZK_CMD}
    echo "Stopping Zookeeper node 02"
    ssh ubuntu@zookeeper-node02 ${STOP_ZK_CMD}
    echo "Stopping Zookeeper node 03"
    ssh ubuntu@zookeeper-node03 ${STOP_ZK_CMD}
}


function startKafka {
    echo "Starting Kafka node 01"
    ssh ubuntu@kafka-node01 ${START_KAFKA_CMD}
    echo "Starting Kafka node 02"
    ssh ubuntu@kafka-node02 ${START_KAFKA_CMD}
    echo "Starting Kafka node 03"
    ssh ubuntu@kafka-node03 ${START_KAFKA_CMD}
    echo "Starting Kafka node 04"
    ssh ubuntu@kafka-node04 ${START_KAFKA_CMD}
}

function stopKafka {
    echo "Stopping Kafka node 01"
    ssh ubuntu@kafka-node01 ${STOP_KAFKA_CMD}
    echo "Stopping Kafka node 02"
    ssh ubuntu@kafka-node02 ${STOP_KAFKA_CMD}
    echo "Stopping Kafka node 03"
    ssh ubuntu@kafka-node03 ${STOP_KAFKA_CMD}
    echo "Stopping Kafka node 04"
    ssh ubuntu@kafka-node04 ${STOP_KAFKA_CMD}
}

function cleanResult {
    echo "Cleaning previous benchmark result"
    ssh ubuntu@load-node01 ${CLEAN_RESULT_CMD}
    ssh ubuntu@load-node02 ${CLEAN_RESULT_CMD}
    ssh ubuntu@load-node03 ${CLEAN_RESULT_CMD}

    ssh ubuntu@zookeeper-node01 ${CLEAN_RESULT_CMD}
    ssh ubuntu@zookeeper-node02 ${CLEAN_RESULT_CMD}
    ssh ubuntu@zookeeper-node03 ${CLEAN_RESULT_CMD}

}

function startFlink {
    echo "Starting Flink"
    ssh ubuntu@stream-node01 ${START_FLINK_CMD}
    sleep 3
    nohup ssh ubuntu@stream-node01 ${START_FLINK_PROC_CMD} &
}

function stopFlink {
    echo "Stopping Flink"
    ssh ubuntu@stream-node01 ${STOP_FLINK_PROC_CMD}
    sleep 5
    nohup ssh ubuntu@stream-node01 ${STOP_FLINK_CMD} &
}


function startSpark {
    echo "Starting Spark Master"
    ssh ubuntu@stream-node01 ${START_SPARK_MASTER_CMD}
    sleep 3
    echo "Starting Spark node 02"
    ssh ubuntu@stream-node02 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark node 03"
    ssh ubuntu@stream-node03 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark node 04"
    ssh ubuntu@stream-node04 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark node 05"
    ssh ubuntu@stream-node05 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark node 06"
    ssh ubuntu@stream-node06 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark node 07"
    ssh ubuntu@stream-node07 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark node 08"
    ssh ubuntu@stream-node08 ${START_SPARK_SLAVE_CMD}
    echo "Starting Spark processing"
    nohup ssh ubuntu@stream-node01 ${START_SPARK_PROC_CMD} &
}

function stopSpark {
    echo "Stopping Spark processing"
    nohup ssh ubuntu@stream-node01 ${STOP_SPARK_PROC_CMD} &
    echo "Stopping Spark node 02"
    ssh ubuntu@stream-node02 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark node 03"
    ssh ubuntu@stream-node03 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark node 04"
    ssh ubuntu@stream-node04 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark node 05"
    ssh ubuntu@stream-node05 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark node 06"
    ssh ubuntu@stream-node06 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark node 07"
    ssh ubuntu@stream-node07 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark node 08"
    ssh ubuntu@stream-node08 ${STOP_SPARK_SLAVE_CMD}
    echo "Stopping Spark Master"
    ssh ubuntu@stream-node01 ${STOP_SPARK_MASTER_CMD}
}

function startRedis {
    echo "Starting Redis"
    nohup ssh ubuntu@redis ${START_REDIS_CMD} &
}

function stopRedis {
    echo "Stopping Redis"
    ssh ubuntu@redis ${STOP_REDIS_CMD}
}


function prepareEnvironment(){
    cleanResult
    startZK
    sleep 5
    startKafka
    sleep 5
    cleanKafka
    startRedis
    sleep 10
}

function destroyEnvironment(){
    sleep 5
    stopRedis
    stopKafka
    sleep 5
    stopZK
}
prepareEnvironment
case $1 in
    flink)
        startFlink
        startLoadData
        sleep ${TEST_TIME}
        stopLoadData
        sleep 60
        stopFlink
    ;;
    spark)
        startSpark
        startLoadData
        sleep ${TEST_TIME}
        stopLoadData
        sleep 60
        stopSpark
    ;;
esac
destroyEnvironment

