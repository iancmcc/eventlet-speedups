#!/usr/bin/env bash


HERE=$(dirname $0)
SPEEDUP_SRC=${HERE}/src/eventlet/speedups
EVENTLET_URL="https://github.com/eventlet/eventlet.git"
EVENTLET_TAG=$1
EVENTLET_REPO=/tmp/eventlet
EVENTLET_SRC=${EVENTLET_REPO}/eventlet


git_tag () {
    if [ ! -d ${EVENTLET_REPO}/.git ]; then
        echo "Checking out eventlet source"
        git checkout ${EVENTLET_URL} ${EVENTLET_REPO} 2>&1 > /dev/null
    else
        echo "Updating eventlet source"
        pushd ${EVENTLET_REPO} 2>&1 > /dev/null
        git reset --hard 2>&1 > /dev/null
        git checkout master 2>&1 > /dev/null
        git pull 2>&1 > /dev/null
        git checkout ${EVENTLET_TAG} 2>&1 > /dev/null
        popd 2>&1 > /dev/null
    fi
    pushd ${EVENTLET_REPO} 2>&1 > /dev/null
    git checkout ${EVENTLET_TAG} 2>&1 > /dev/null
    echo "Checking out tag ${EVENTLET_TAG}"
    popd 2>&1 > /dev/null
}

cleanup_local () {
    echo "Cleaning up local files"
    find ${HERE} -name '*.c' -exec rm -rf {} \;
}

generate_c () {
    cd ${HERE}
    for f in greenio semaphore queue timeout hubs/hub hubs/poll hubs/timer; do
        FNAME=${SPEEDUP_SRC}/${f}.c
        cython ${EVENTLET_SRC}/${f}.py -o ${FNAME}
        git add ${FNAME}
    done
    
    TRAMPOLINE=${EVENTLET_SRC}/hubs/trampoline.py
    cp ${EVENTLET_SRC}/hubs/__init__.py ${TRAMPOLINE}
    cython ${TRAMPOLINE} -o ${SPEEDUP_SRC}/hubs/trampoline.c
    git add ${SPEEDUP_SRC}/hubs/trampoline.c
    rm -f ${TRAMPOLINE}
}

create_tag () {
    git commit -am "Generated C versions of ${EVENTLET_TAG}"
    git tag -d ${EVENTLET_TAG} 2>&1 > /dev/null
    git tag ${EVENTLET_TAG}
}

cleanup_local
git_tag
generate_c
create_tag

