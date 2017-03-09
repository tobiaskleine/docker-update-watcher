#!/bin/sh

while IFS=, read image deployment
do
    echo "======================================================================"
    echo " checking updates for $image..."
    echo "======================================================================"
    
    # pull newest container image for ${image}
    docker pull startcoding/docker-integration-test:staging
    docker images -q --no-trunc $image > ${deployment}.newest
    echo "Newest container image ID for $image:"
    cat docker-integration-test.newest
    # check if the newest image is already deployed
    if ! cmp ${deployment}.newest ${deployment}.current >/dev/null 2>&1
    then
        echo "The world is changing! The new image will be deployed now."
        cat ${deployment}.newest > ${deployment}.current
        # kubectl get deployment -o yaml scweb-frontend-staging > /tmp/scweb-frontend-staging-editing.yaml
        # perl -0777 -pe 's/name\: IMAGE_VERSION_ID\n\          value\: .*/name: IMAGE_VERSION_ID\n          value: say nothing/g' /tmp/scweb-frontend-staging-editing.yaml > /tmp/scweb-frontend-staging-new.yaml
        # kubectl apply -f /tmp/scweb-frontend-staging-new.yaml
    fi
done < /config/deployments.csv
