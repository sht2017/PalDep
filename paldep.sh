#!/usr/bin/env bash


HOME_PATH=~
WORK_ROOT=${HOME_PATH}/PalServer
BINARY=${WORK_ROOT}/bin
ROOTFS=${WORK_ROOT}/rootfs
JQ=${BINARY}/jq
PROOT=${BINARY}/proot

check_dependency() {
    [ ! -d ${HOME_PATH} ] && echo "Home directory does not exist. Abort." && exit 1
    [ -z "$(command -v tar)" ] && echo "Command \"tar\" not found. Abort." && exit 1
    [ -z "$(command -v curl)" ] && echo "Command \"curl\" not found. Abort." && exit 1
}

init() {
    rm -rf ${WORK_ROOT}
    mkdir ${WORK_ROOT} ${BINARY} ${ROOTFS} 
}

clean() {
    rm -rf ${WORK_ROOT}
}


path_parse() {
    local path="$1"
    local exclude_dirs=($2)

    local exclude_params=""
    for dir in "${exclude_dirs[@]}"; do
        exclude_params+=" -path \"$dir\" -prune -o"
    done

    local cmd="find \"$path\" -mindepth 1 -maxdepth 1"
    if [[ -n "$exclude_params" ]]; then
        cmd+="$exclude_params -print0"
    else
        cmd+=" -print0"
    fi

    eval "$cmd" | while IFS= read -r -d $'\0' file; do
        printf -- '-b %s:%s ' "$file" "$file"
    done
}

install() {
    echo -e "check dependency"
    check_dependency

    echo -e "[info] initialize"
    init

    echo -e "[info] download dependency (JQ, required by [PRoot])"
    curl -\#L "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" -o ${JQ} && chmod +x ${JQ}

    echo -e "[info] download dependency (PRoot, required by [\$core])"
    curl -\#L "https://gitlab.com/api/v4/projects/proot%2Fproot/jobs/$(${JQ} '.[] | select(.stage == "dist") | .id' <(curl -s "https://gitlab.com/api/v4/projects/proot%2Fproot/pipelines/$(${JQ} '.[0].id' <(curl -s "https://gitlab.com/api/v4/projects/proot%2Fproot/pipelines?status=success"))/jobs"))/artifacts" -o /tmp/artifacts && unzip -jq /tmp/artifacts dist/proot -d ${BINARY} && chmod +x ${PROOT}
    rm -rf artifacts

    echo -e "[info] download dependency (Ubuntu-22.04, required by [\$core])"
    tar -zxf <(curl -\#L "https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04-base-amd64.tar.gz") -C ${ROOTFS}

    echo -e "[info] finish download dependency"


    ${PROOT} -S ${ROOTFS} -w /home/steam -v -1 -i 0:0 /bin/bash --rcfile <(cat deploy.sh)
    exit 0
}

[ -z "$1" ] && echo -e "Useage: ./paldep.sh install\t\tstart deploy\n        ./paldep.sh clean\t\tremove all files" && exit 0
[ "$1" != "install" ] && [ "$1" != "clean" ] && echo "invalid input" && echo -e "Useage: ./paldep.sh install\t\tstart deploy\n        ./paldep.sh clean\t\tremove all files" && exit 1

$1