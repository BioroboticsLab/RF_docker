function gitlab-fetch-artifacts {
    curl -o artifacts.zip --header "JOB-TOKEN: $CI_JOB_TOKEN" "https://git.imp.fu-berlin.de/api/v4/projects/$1/jobs/artifacts/$2/download?job=$3"
    7z e artifacts.zip; rm artifacts.zip
}

function gitlab-trigger-pipeline {
    curl --request POST --form "token=$2" --form "ref=$3" "https://git.imp.fu-berlin.de/api/v4/projects/$1/trigger/pipeline"
}

function cmake-integrate-package {
    7z e $1-*.tar.xz; rm $1-*.tar.xz
    7z x $1-*.tar; rm $1-*.tar
    ln -s $(realpath $1-*) /usr/local/$1
}
