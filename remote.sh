#!/usr/bin/env bash

. ./remoteInvocation.sh --source-only
. ./variable.sh --source-only




TPS_RANGE=1000
TPS_LIMIT=15000
INITIAL_TPS=${TPS}

SHORT_SLEEP=3
LONG_SLEEP=5

WAIT_AFTER_STOP_PRODUCER=30
WAIT_AFTER_REBOOT_SERVER=30


# Before running kafka stream benchmark comment the first line and uncomment the second line after this line.
KAFKA_FOLDER="kafka_2.11-0.11.0.2"
#KAFKA_FOLDER="kafka_2.11-1.1.0"

PROJECT_DIR="/root/stream-benchmarking"



CLEAN_LOAD_RESULT_CMD="rm *.load; rm -rf $PROJECT_DIR/$STORM_DIR/logs/*;rm -rf $PROJECT_DIR/$STORM_DIR/logs/*; rm -rf $PROJECT_DIR/$SPARK_DIR/work/*; rm -rf /root/kafka-logs/*;"
REBOOT_CMD="reboot;"
SHUTDOWN_CMD="shutdown;"
CLEAN_RESULT_CMD="cd $PROJECT_DIR; rm data/*.txt; rm -rf data/workers; rm -rf $JSTORM_DIR/data/*; rm -rf /root/zookeeper/version-2/*; rm -rf $PROJECT_DIR/$JSTORM_DIR/data/*"

CLEAN_BUILD_BENCHMARK="cd $PROJECT_DIR; ./stream-bench.sh SETUP_BENCHMARK"
SETUP_KAFKA="cd $PROJECT_DIR; ./stream-bench.sh SETUP_KAFKA"

CHANGE_TPS_CMD="sed -i “s/TPS:-${INITIAL_TPS}/TPS:-$TPS/g” $PROJECT_DIR/variable.sh;"

LOAD_START_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_LOAD;"
LOAD_STOP_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_LOAD;"

DELETE_TOPIC="cd $PROJECT_DIR/$KAFKA_FOLDER; ./bin/kafka-topics.sh --delete --zookeeper zookeeper-node01:2181,zookeeper-node02:2181,zookeeper-node03:2181 --topic $TOPIC;"
CREATE_TOPIC="cd $PROJECT_DIR/$KAFKA_FOLDER; ./bin/kafka-topics.sh --create --zookeeper zookeeper-node01:2181,zookeeper-node02:2181,zookeeper-node03:2181 --replication-factor 1 --partitions $PARTITIONS --topic $TOPIC;"

START_MONITOR_CPU="top -b -d 1 | grep --line-buffered Cpu > cpu.load;"
START_MONITOR_MEM="top -b -d 1 | grep --line-buffered 'KiB Mem' > mem.load;"
STOP_MONITOR="ps aux | grep top | awk {'print \$2'} | xargs sudo kill;"

START_STORM_NIMBUS_CMD="cd $PROJECT_DIR; ./$STORM_DIR/bin/storm nimbus;"
STOP_STORM_NIMBUS_CMD="ps aux | grep storm | awk {'print \$2'} | xargs sudo kill;"
START_STORM_SUPERVISOR_CMD="cd $PROJECT_DIR; ./$STORM_DIR/bin/storm supervisor;"
STOP_STORM_SUPERVISOR_CMD="ps aux | grep storm | awk {'print \$2'} | xargs sudo kill;"
START_STORM_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_STORM_TOPOLOGY;"
STOP_STORM_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_STORM_TOPOLOGY;"

START_JSTORM_NIMBUS_CMD="cd $PROJECT_DIR; ./$JSTORM_DIR/bin/jstorm.py nimbus;"
STOP_JSTORM_NIMBUS_CMD="ps aux | grep jstorm | awk {'print \$2'} | xargs sudo kill;"
START_JSTORM_SUPERVISOR_CMD="cd $PROJECT_DIR; ./$JSTORM_DIR/bin/jstorm.py supervisor;"
STOP_JSTORM_SUPERVISOR_CMD="ps aux | grep jstorm | awk {'print \$2'} | xargs sudo kill;"
START_JSTORM_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_JSTORM_TOPOLOGY;"
STOP_JSTORM_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_JSTORM_TOPOLOGY;"


START_HERON_CMD="heron-admin standalone cluster start;"
START_HERON_API_CMD="heron-apiserver --cluster standalone;"
STOP_HERON_CMD="yes yes | heron-admin standalone cluster stop;"
START_HERON_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_HERON_PROCESSING;"
STOP_HERON_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_HERON_PROCESSING;"

COMMENT_ZOO="sed -i \"s/heron.statemgr.connection.string/#heron.statemgr.connection.string/g\" ~/.heron/conf/standalone/statemgr.yaml;"
ADD_ZOO="echo \"heron.statemgr.connection.string: zookeeper-node03:2181,zookeeper-node02:2181,zookeeper-node01:2181\" >> ~/.heron/conf/standalone/statemgr.yaml"

START_FLINK_CMD="cd $PROJECT_DIR; ./$FLINK_DIR/bin/start-cluster.sh;"
STOP_FLINK_CMD="cd $PROJECT_DIR; ./$FLINK_DIR/bin/stop-cluster.sh;"
START_FLINK_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_FLINK_PROCESSING;"
STOP_FLINK_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_FLINK_PROCESSING;"

START_SPARK_CMD="cd $PROJECT_DIR/$SPARK_DIR; ./sbin/start-all.sh;"
STOP_SPARK_CMD="cd $PROJECT_DIR/$SPARK_DIR; ./sbin/stop-all.sh;"
START_SPARK_RDD_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_SPARK_CP_PROCESSING;"
STOP_SPARK_RDD_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_SPARK_CP_PROCESSING;"

START_SPARK_DSTREAM_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_SPARK_PROCESSING;"
STOP_SPARK_DSTREAM_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_SPARK_PROCESSING;"

START_SPARK_DATASET_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_SPARK_CP_PROCESSING;"
STOP_SPARK_DATASET_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_SPARK_CP_PROCESSING;"


START_ZK_CMD="cd $PROJECT_DIR/$KAFKA_FOLDER; ./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties"
STOP_ZK_CMD="cd $PROJECT_DIR/$KAFKA_FOLDER; ./bin/zookeeper-server-stop.sh;"

START_KAFKA_CMD="cd $PROJECT_DIR/$KAFKA_FOLDER; ./bin/kafka-server-start.sh -daemon config/server.properties"
STOP_KAFKA_CMD="cd $PROJECT_DIR/$KAFKA_FOLDER; ./bin/kafka-server-stop.sh;"

START_KAFKA_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_KAFKA_PROCESSING;"
STOP_KAFKA_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_KAFKA_PROCESSING;"

START_JET_CMD="cd $PROJECT_DIR; ./$HAZELCAST_DIR/bin/jet-start.sh;"
STOP_JET_CMD="cd $PROJECT_DIR; ./$HAZELCAST_DIR/bin/jet-stop.sh;"
START_JET_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_JET_PROCESSING;"
STOP_JET_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_JET_PROCESSING;"
START_JET_EMBEDDED_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_JET_EMBEDDED_PROCESSING;"
STOP_JET_EMBEDDED_PROC_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_JET_EMBEDDED_PROCESSING;"

START_REDIS_CMD="cd $PROJECT_DIR; ./stream-bench.sh START_REDIS;"
STOP_REDIS_CMD="cd $PROJECT_DIR; ./stream-bench.sh STOP_REDIS;"

PULL_GIT="cd $PROJECT_DIR; git reset --hard HEAD; git pull origin master;"


C1="{\"type\":\"resize\",\"size\":\"c-1vcpu-2gb\"}"
C2="{\"type\":\"resize\",\"size\":\"c-2\"}"
C4="{\"type\":\"resize\",\"size\":\"c-4\"}"
C16="{\"type\":\"resize\",\"size\":\"c-16\"}"
DG_POWER_OFF="{\"type\":\"power_off\"}"
DG_POWER_ON="{\"type\":\"power_on\"}"




function runAllServers {
    runCommandStreamServers "${1}" "nohup"
    runCommandZKServers "${1}" "nohup"
    runCommandKafkaServers "${1}" "nohup"
    runCommandLoadServers "${1}" "nohup"
    runCommandRedisServer "${1}" "nohup"
}

function stopLoadData {
    echo "Main loaders stopping"
    runCommandLoadServers "${LOAD_STOP_CMD}" "nohup"
}


function startLoadData {
    echo "Main loaders starting"
    runCommandLoadServers "${LOAD_START_CMD}" "nohup"

}

function cleanKafka {
    #FIXME delete for Kafka benchmark
    echo "Deleted kafka topic"
    runCommandRedisServer "${DELETE_TOPIC}"
    sleep ${SHORT_SLEEP}
    echo "Created kafka topic"
    runCommandRedisServer "${CREATE_TOPIC}"
}

function startZK {
    echo "Starting Zookeepers"
    runCommandZKServers "${START_ZK_CMD}"
}

function stopZK {
    echo "Stopping Zookeepers"
    runCommandZKServers "${STOP_ZK_CMD}"
}


function startKafka {
    echo "Starting Kafka nodes"
    runCommandKafkaServers "${START_KAFKA_CMD}"
}

function stopKafka {
    echo "Stopping Kafka nodes"
    runCommandKafkaServers "${STOP_KAFKA_CMD}"
}

function cleanResult {
    echo "Cleaning previous benchmark result"
    runCommandStreamServers "${CLEAN_LOAD_RESULT_CMD}" "nohup"
    runCommandKafkaServers "${CLEAN_LOAD_RESULT_CMD}" "nohup"
    runCommandRedisServer "${CLEAN_RESULT_CMD}" "nohup"
    runCommandZKServers "${CLEAN_RESULT_CMD}" "nohup"
}


function startHeron {
    echo "Starting Heron"
    runCommandMasterStreamServers "${START_ZK_CMD}"
    runCommandMasterStreamServers "${START_HERON_CMD}"
    #runCommandMasterStreamServers "${COMMENT_ZOO}"
    #runCommandMasterStreamServers "${ADD_ZOO}"
}

function stopHeron {
    echo "Stopping Heron"
    runCommandMasterStreamServers "${STOP_HERON_CMD}"
    runCommandMasterStreamServers "${STOP_ZK_CMD}"
}

function startHeronProcessing {
    echo "Starting Heron Processing"
    runCommandMasterStreamServers "${START_HERON_PROC_CMD}"
}

function stopHeronProcessing {
    echo "Stopping Heron Processing"
    runCommandMasterStreamServers "${STOP_HERON_PROC_CMD}"
}

function startJet {
    echo "Starting Jet"
    runCommandStreamServers "${START_JET_CMD}" "nohup"
}

function stopJet {
    echo "Stopping Jet"
    runCommandStreamServers "${STOP_JET_CMD}"
}

function startJetProcessing {
    echo "Starting Jet Processing"
    runCommandMasterStreamServers "${START_JET_PROC_CMD}" "nohup"
}

function stopJetProcessing {
    echo "Stopping Jet Processing"
    runCommandMasterStreamServers "${STOP_JET_PROC_CMD}" "nohup"
 }

function startJetEmbeddedProcessing {
    echo "Starting Jet Processing"
    runCommandStreamServers "${START_JET_EMBEDDED_PROC_CMD}" "nohup"
}

function stopJetEmbeddedProcessing {
    echo "Stopping Jet Processing"
    runCommandStreamServers "${STOP_JET_EMBEDDED_PROC_CMD}" "nohup"
 }

function startFlink {
    echo "Starting Flink"
    runCommandMasterStreamServers "${START_FLINK_CMD}"
}

function stopFlink {
    echo "Stopping Flink"
    runCommandMasterStreamServers "${STOP_FLINK_CMD}"
}

function startFlinkProcessing {
    echo "Starting Flink Processing"
    runCommandMasterStreamServers "${START_FLINK_PROC_CMD}" "nohup"
}

function stopFlinkProcessing {
    echo "Stopping Flink Processing"
    runCommandMasterStreamServers "${STOP_FLINK_PROC_CMD}" "nohup"
 }

function startSpark {
    echo "Starting Spark"
    runCommandMasterStreamServers "${START_SPARK_CMD}"
}

function stopSpark {
    echo "Stopping Spark"
    runCommandMasterStreamServers "${STOP_SPARK_CMD}"
}

function startSparkProcessing {
    echo "Starting Spark processing"
    case $1 in
        dstream)
            runCommandMasterStreamServers "${START_SPARK_DSTREAM_PROC_CMD}" "nohup"
        ;;
        dataset)
            runCommandMasterStreamServers "${START_SPARK_DATASET_PROC_CMD}" "nohup"
        ;;
        *)
            echo "Which spark processing would you like to start"
        ;;
    esac
}

function stopSparkProcessing {
    echo "Stopping Spark processing"
     case $1 in
        dstream)
            runCommandMasterStreamServers "${STOP_SPARK_DSTREAM_PROC_CMD}" "nohup"
        ;;
        dataset)
            runCommandMasterStreamServers "${STOP_SPARK_DATASET_PROC_CMD}" "nohup"
        ;;
        *)
            echo "Which spark processing would you like to stop"
        ;;
    esac
}

function startKafkaProcessing {
    echo "Starting Kafka processing"
    runCommandStreamServers "${START_KAFKA_PROC_CMD}" "nohup"
}

function stopKafkaProcessing {
    echo "Stopping Kafka processing"
    runCommandStreamServers "${STOP_KAFKA_PROC_CMD}" "nohup"
}

function startStorm {
    echo "Starting Storm"
    runCommandMasterStreamServers "${START_STORM_NIMBUS_CMD}" "nohup"
    sleep ${SHORT_SLEEP}
    runCommandSlaveStreamServers "${START_STORM_SUPERVISOR_CMD}" "nohup"
}

function stopStorm {
    echo "Stopping Storm"
    runCommandSlaveStreamServers "${STOP_STORM_SUPERVISOR_CMD}" "nohup"
    sleep ${SHORT_SLEEP}
    runCommandMasterStreamServers "${STOP_STORM_NIMBUS_CMD}" "nohup"
}

function startStormProcessing {
    echo "Starting Storm processing"
    runCommandMasterStreamServers "${START_STORM_PROC_CMD}" "nohup"
}

function stopStormProcessing {
    echo "Stopping Storm processing"
    runCommandMasterStreamServers "${STOP_STORM_PROC_CMD}" "nohup"
}

function startJStorm {
    echo "Starting JStorm"
    runCommandMasterStreamServers "${START_JSTORM_NIMBUS_CMD}" "nohup"
    sleep ${SHORT_SLEEP}
    runCommandSlaveStreamServers "${START_JSTORM_SUPERVISOR_CMD}" "nohup"
}

function stopJStorm {
    echo "Stopping JStorm"
    runCommandSlaveStreamServers "${STOP_JSTORM_SUPERVISOR_CMD}" "nohup"
    sleep ${SHORT_SLEEP}
    runCommandMasterStreamServers "${STOP_JSTORM_NIMBUS_CMD}" "nohup"
}

function startJStormProcessing {
    echo "Starting JStorm processing"
    runCommandMasterStreamServers "${START_JSTORM_PROC_CMD}" "nohup"
}

function stopJStormProcessing {
    echo "Stopping JStorm processing"
    runCommandMasterStreamServers "${STOP_JSTORM_PROC_CMD}" "nohup"
}

function startMonitoring(){
    echo "Start Monitoring"
    runCommandStreamServers "${START_MONITOR_CPU}" "nohup"
    runCommandStreamServers "${START_MONITOR_MEM}" "nohup"
    runCommandKafkaServers "${START_MONITOR_CPU}" "nohup"
    runCommandKafkaServers "${START_MONITOR_MEM}" "nohup"
}

function stopMonitoring(){
    echo "Stop Monitoring"
    runCommandStreamServers "${STOP_MONITOR}" "nohup"
    runCommandKafkaServers "${STOP_MONITOR}" "nohup"
}

function changeTps(){
    #TODO replace with CHANGE_TPS_CMD variable
    runCommandLoadServers "sed -i \"s/TPS:-${INITIAL_TPS}/TPS:-$1/g\" stream-benchmarking/variable.sh" "nohup"
}




function startRedis {
    echo "Starting Redis"
    runCommandRedisServer "${START_REDIS_CMD}" "nohup"
    sleep ${SHORT_SLEEP}
}

function stopRedis {
    echo "Stopping Redis"
    runCommandRedisServer "${STOP_REDIS_CMD}"
    sleep ${SHORT_SLEEP}
}


function prepareEnvironment(){
    cleanResult
    sleep ${SHORT_SLEEP}
    startZK
    sleep ${LONG_SLEEP}
    startKafka
    sleep ${LONG_SLEEP}
    cleanKafka
    startRedis
    sleep ${LONG_SLEEP}
}

function destroyEnvironment(){
    sleep ${SHORT_SLEEP}
    stopRedis
    stopKafka
    sleep ${SHORT_SLEEP}
    stopZK
}


function getBenchmarkResult(){

    if [ "$1" == "spark" ]; then
        ENGINE_PATH=${1}_${2}_${BATCH}
        SUB_PATH=TPS_${TPS}_DURATION_${TEST_TIME}
        PATH_RESULT=result/${ENGINE_PATH}/${SUB_PATH}
    else
        ENGINE_PATH=${1}
        SUB_PATH=TPS_${TPS}_DURATION_${TEST_TIME}
        PATH_RESULT=result/${ENGINE_PATH}/${SUB_PATH}
    fi
    rm -rf ${PATH_RESULT};
    mkdir -p ${PATH_RESULT}
    getResultFromStreamServer "${PATH_RESULT}"
    getResultFromKafkaServer "${PATH_RESULT}"
    getResultFromRedisServer "${PATH_RESULT}"
    sleep ${SHORT_SLEEP}
    Rscript reporting/reporting.R ${ENGINE_PATH} ${INITIAL_TPS} ${TEST_TIME} 15
}

function benchmark(){
    startMonitoring
    sleep ${LONG_SLEEP}
    startLoadData
    sleep ${TEST_TIME}
    stopLoadData
    sleep ${WAIT_AFTER_STOP_PRODUCER}
    stopMonitoring
}


function runSystem(){
    prepareEnvironment
    case $1 in
         jet_embedded)
            startJetEmbeddedProcessing
            benchmark $1
            sleep ${SHORT_SLEEP}
            stopJetEmbeddedProcessing
        ;;
         jet)
            startJet
            sleep ${SHORT_SLEEP}
            startJetProcessing
            benchmark $1
            sleep ${SHORT_SLEEP}
            stopJet
        ;;
        flink)
            startFlink
            sleep ${SHORT_SLEEP}
            startFlinkProcessing
            benchmark $1
            stopFlinkProcessing
            sleep ${SHORT_SLEEP}
            stopFlink
        ;;
        spark)
            startSpark
            sleep ${SHORT_SLEEP}
            startSparkProcessing $2
            benchmark $1
            stopSparkProcessing $2
            sleep ${SHORT_SLEEP}
            stopSpark
        ;;
        storm)
            startStorm
            sleep ${SHORT_SLEEP}
            startStormProcessing
            sleep ${LONG_SLEEP}
            benchmark $1
            stopStormProcessing
            sleep ${SHORT_SLEEP}
            stopStorm
        ;;
        jstorm)
            startJStorm
            sleep ${LONG_SLEEP}
            startJStormProcessing
            sleep ${LONG_SLEEP}
            sleep ${LONG_SLEEP}
            benchmark $1
            stopJStormProcessing
            sleep ${LONG_SLEEP}
            sleep ${LONG_SLEEP}
            stopJStorm
            sleep ${LONG_SLEEP}
        ;;
        heron)
            startHeron
            startHeronProcessing
            sleep ${LONG_SLEEP}
            benchmark $1
            stopHeronProcessing
            sleep ${SHORT_SLEEP}
            stopHeron
        ;;
        kafka)
            sleep ${LONG_SLEEP}
            startKafkaProcessing
            benchmark $1
            stopKafkaProcessing
            sleep ${SHORT_SLEEP}
        ;;
    esac
    destroyEnvironment
    getBenchmarkResult $1 $2

}

function stopAll (){
    stopLoadData
    stopMonitoring
    stopKafkaProcessing
    stopJet
    stopFlinkProcessing
    stopFlink
    stopSparkProcessing "dataset"
    stopSparkProcessing "dstream"
    stopSpark
    stopStormProcessizng
    stopStorm
    stopJStormProcessing
    stopJStorm
    stopHeronProcessing
    stopHeron
    cleanKafka
    destroyEnvironment
    cleanResult
}



function benchmarkLoop (){
    while true; do
        runAllServers "${PULL_GIT}"
        sleep ${SHORT_SLEEP}
        if (("$TPS" > "$TPS_LIMIT")); then
            break
        fi
        changeTps "${TPS}"
        runSystem $1 $2
        TPS=$[$TPS + $TPS_RANGE]
    done
    rebootServer
    sleep ${WAIT_AFTER_REBOOT_SERVER}
    TPS=${INITIAL_TPS}
}


case $1 in
    flink)
        benchmarkLoop "flink"
    ;;
    spark)
        benchmarkLoop "spark" $2
    ;;
    jet)
        benchmarkLoop "jet"
    ;;
    jet_embedded)
        benchmarkLoop "jet_embedded"
    ;;
    storm)
        changeTps ${TPS}
        benchmarkLoop "storm"
    ;;
    jstorm)
        changeTps ${TPS}
        benchmarkLoop "jstorm"
    ;;
    kafka)
        benchmarkLoop "kafka"
    ;;
    heron)
        benchmarkLoop "heron"
    ;;
    all)
        benchmarkLoop "spark" "dataset"
        benchmarkLoop "spark" "dstream"
        benchmarkLoop "storm"
        benchmarkLoop "jstorm"
        benchmarkLoop "flink"
        benchmarkLoop "kafka"
        benchmarkLoop "heron"
        benchmarkLoop "jet"
    ;;
    start)
        case $2 in
            flink)
                startFlink
            ;;
            spark)
                startSpark
            ;;
            storm)
                startZK
                sleep ${SHORT_SLEEP}
                startStorm
            ;;
            jstorm)
                startZK
                sleep ${SHORT_SLEEP}
                startJStorm
            ;;
            heron)
                startZK
                sleep ${SHORT_SLEEP}
                startHeron
            ;;
            process)
                startJStormProcessing
            ;;
            redis)
                startRedis
            ;;
            kafka)
                startKafka
            ;;
            zoo)
                startZK
            ;;
            prepare)
                prepareEnvironment
            ;;
            load)
                startLoadData
            ;;
        esac
    ;;
    stop)
        case $2 in
            flink)
                stopFlink
            ;;
            spark)
                stopSpark
            ;;
            storm)
                stopStorm
                sleep ${SHORT_SLEEP}
                stopZK
            ;;
            jstorm)
                stopJStorm
                sleep ${SHORT_SLEEP}
                stopZK
            ;;
            heron)
                stopHeron
                sleep ${SHORT_SLEEP}
                stopZK
            ;;
            process)
                stopJStormProcessing
            ;;
            zoo)
                stopZK
            ;;
            load)
                stopLoadData
            ;;
            redis)
                stopRedis
            ;;
            kafka)
                stopKafka
            ;;
            prepare)
                destroyEnvironment
            ;;
            all)
                stopAll
            ;;
        esac
    ;;
    load)
        startLoadData
    ;;
    push)
        git add --all
        git commit -am "$2"
        git push origin master
        runAllServers "${PULL_GIT}"
    ;;
    report)
        Rscript reporting.R
    ;;
    reboot)
        runAllServers "${REBOOT_CMD}"
    ;;
    shutdown)
        runAllServers "${SHUTDOWN_CMD}"
    ;;
    build)
        runCommandStreamServers "${CLEAN_BUILD_BENCHMARK}" "nohup"
    ;;
    clean)
        cleanResult
    ;;
    resize_up)
        runForRedisDroplets "${C4}"
        runForKafkaDroplets "${C16}"
        runForStreamDroplets "${C16}"

    ;;
    resize_down)
        runForRedisDroplets "${C2}"
        runForKafkaDroplets "${C2}"
        runForStreamDroplets "${C2}"
    ;;
    power_off)
        runOnAllDroplets "${DG_POWER_OFF}"
    ;;
    power_on)
        runOnAllDroplets "${DG_POWER_ON}"
    ;;
    result)
        getResultFromStreamServer "result/$1/TPS_4000_DURATION_600"
        getResultFromKafkaServer "result/$1/TPS_4000_DURATION_600"
        getResultFromRedisServer "result/$1/TPS_4000_DURATION_600"
    ;;
    test)
        #runSystem $2 $3
        TPS=$[15000]
        changeTps ${TPS}
        runSystem $2 $3
        #Rscript --vanilla reporting.R "spark_dstream_1000" 1000 60
        #Rscript --vanilla reporting.R "spark_dataset_1000" 1000 60
        #Rscript --vanilla reporting.R "flink" 1000 60
        #Rscript --vanilla reporting.R "storm" 1000 60
        echo "Please Enter valid command"


esac
