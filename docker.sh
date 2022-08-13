#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function usage {
    cat <<EOF

Usage: $0 <arguments>

Arguments:
    -r      : run docker container
    -b      : build docker image
    -h      : show this help info

EOF
}

function INFO {
    echo -e "\e[92m\e[1mINFO\e[0m: $*\n"
}

function ERROR {
    echo -e "\e[31m\e[1mERROR\e[0m: $*\n"
}

VERSION="1"

IMAGE="linux-kernel-development-ubuntu:${VERSION}"
CONTAINER="linux-kernel-${VERSION}-${USER}"

DOCKER_FILE="${SCRIPT_DIR}/Dockerfile-ubuntu18"

function build_docker() {
    INFO "Build docker image ${IMAGE}"
    docker build \
        -f "${DOCKER_FILE}" \
        -t "${IMAGE}" .
}

function run_docker() {
    if docker inspect "${CONTAINER}" >/dev/null 2>&1; then
        INFO "Reattaching to running container ${CONTAINER}"
        docker attach "${CONTAINER}"
    else
        INFO "Creating container ${CONTAINER}"
        docker run -it \
            --name="${CONTAINER}" \
            "${IMAGE}"
    fi
}

function pull_docker() {
    INFO "Pull docker image ${IMAGE}"
}

function push_docker() {
    INFO "Push docker image ${IMAGE}"
}

while getopts rbh OPT; do
    case ${OPT} in
    r)
        run_docker
        ;;
    b)
        build_docker
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done
