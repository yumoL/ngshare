#!/bin/bash -e

HELM_CHART_VER=0.9.0-beta.4

function build_hub_img {
    eval $(minikube docker-env)
    cd ../../..
    docker build -f ngshare/testing/minikube/Dockerfile-hub -t hub-testing:0.0.1 .
    cd -
    eval $(minikube docker-env -u)
}

function build_singleuser_img {
    eval $(minikube docker-env)
    docker build -f Dockerfile-singleuser -t singleuser-testing:0.0.1 .
    eval $(minikube docker-env -u)
}

function build_ngshare_img {
    eval $(minikube docker-env)
    cd ../..
    docker build -f testing/minikube/Dockerfile-ngshare -t ngshare-testing:0.0.1 .
    cd -
    eval $(minikube docker-env -u)
}

case $1 in
    init )
        minikube start --memory 10g
        helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
        helm repo update ;;
    install )
        build_hub_img
        build_singleuser_img
        build_ngshare_img
        helm install jhub jupyterhub/jupyterhub --version=$HELM_CHART_VER -f config.yaml --debug
        minikube service list ;;
    uninstall )
        helm uninstall jhub
        kubectl delete pod jupyter-service-ngshare ;;
    reinstall )
        helm uninstall jhub
        build_hub_img
        build_singleuser_img
        build_ngshare_img
        sleep 10 # sometimes PVCs arent unmounted properly, giving an error when doing helm install
        helm install jhub jupyterhub/jupyterhub --version=$HELM_CHART_LOC -f config.yaml --debug
        minikube service list ;;
    upgrade )
        build_hub_img
        build_singleuser_img
        build_ngshare_img
        helm upgrade jhub jupyterhub/jupyterhub --version=$HELM_CHART_LOC -f config.yaml --debug
        minikube service list ;;
    delete )
        minikube delete ;;
    reboot )
        minikube stop
        minikube start ;;
    *)
        echo "Minikube testing script for ngshare project"
        echo "Usage: $0 COMMAND"
        echo "Available commands:"
        echo "    init: Initializes minikube environment"
        echo "    install: Installs testing setup on minikube"
        echo "    uninstall: Uninstalls testing setup on minikube"
        echo "    upgrade: Updates the testing environment with latest changes. This can be used for fast testing when Z2JH is already installed"
        echo "    reinstall: Does an uninstall and install, for the cases where 'upgrade' doesn't cut it due to messed up pods"
        echo "    delete: Deletes minikube VM, so you can start fresh with init"
        echo "    reboot: Restarts minikube VM, which for some reason occasionally crashes" ;;
esac
