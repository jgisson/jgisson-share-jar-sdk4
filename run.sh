#!/bin/sh

export COMPOSE_FILE_PATH="${PWD}/target/classes/docker/docker-compose.yml"

if [ -z "${M2_HOME}" ]; then
  export MVN_EXEC="mvn"
else
  export MVN_EXEC="${M2_HOME}/bin/mvn"
fi

start() {
#    docker volume create jgisson-share-jar-sdk4-acs-volume
#    docker volume create jgisson-share-jar-sdk4-db-volume
#    docker volume create jgisson-share-jar-sdk4-ass-volume
    docker-compose -f "$COMPOSE_FILE_PATH" up --build -d
}

start_share() {
    docker-compose -f "$COMPOSE_FILE_PATH" up --build -d jgisson-share-jar-sdk4-share
}

down() {
    if [ -f "$COMPOSE_FILE_PATH" ]; then
        docker-compose -f "$COMPOSE_FILE_PATH" down
    fi
}

#purge() {
#    docker volume rm -f jgisson-share-jar-sdk4-acs-volume
#    docker volume rm -f jgisson-share-jar-sdk4-db-volume
#    docker volume rm -f jgisson-share-jar-sdk4-ass-volume
#}

build() {
    $MVN_EXEC clean package
}

build_share() {
    docker-compose -f "$COMPOSE_FILE_PATH" kill jgisson-share-jar-sdk4-share
    yes | docker-compose -f "$COMPOSE_FILE_PATH" rm -f jgisson-share-jar-sdk4-share
    $MVN_EXEC clean package
}

tail() {
    docker-compose -f "$COMPOSE_FILE_PATH" logs -f
}

tail_all() {
    docker-compose -f "$COMPOSE_FILE_PATH" logs --tail="all"
}

case "$1" in
  build_start)
    down
    build
    start
    tail
    ;;
  start)
    start
    tail
    ;;
  stop)
    down
    ;;
  purge)
    down
#    purge
    ;;
  tail)
    tail
    ;;
  reload_share)
    build_share
    start_share
    tail
    ;;
  *)
    echo "Usage: $0 {build_start|start|stop|purge|tail|reload_share}"
esac