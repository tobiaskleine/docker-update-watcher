#!/bin/sh

docker login --username $DOCKER_USER --password $DOCKER_PASSWORD

while IFS=, read image deployment
do
    echo "======================================================================"
    echo " checking updates for $image..."
    echo "======================================================================"
    
    # pull newest container image for ${image}
    docker pull $image
    docker images -q --no-trunc $image > /tmp/${deployment}.newest
    echo "Newest container image ID for $image:"
    cat /tmp/${deployment}.newest
    # check if the newest image is already deployed
    if ! cmp /tmp/${deployment}.newest /tmp/${deployment}.current >/dev/null 2>&1
    then
        echo "The world is changing! The new image will be deployed now."
        cat /tmp/${deployment}.newest > /tmp/${deployment}.current
        export IMAGE_VERSION_ID=`cat /tmp/${deployment}.newest`
        kubectl get deployment -o yaml ${deployment} > /tmp/${deployment}-editing.yaml
        perl -0777 -pe "s/name\: IMAGE_VERSION_ID\n\          value\: .*/name: IMAGE_VERSION_ID\n          value: IVD${IMAGE_VERSION_ID}/g" /tmp/${deployment}-editing.yaml > /tmp/${deployment}-new.yaml
        kubectl apply -f /tmp/${deployment}-new.yaml
    fi
done < /config/deployments.csv
