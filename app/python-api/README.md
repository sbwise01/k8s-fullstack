# flask-hello-world
Simple flask app in a docker container.

## Build instructions
1. `docker build -t sbwise/flaskhelloworld:0.2.5 .`
1. `docker push sbwise/flaskhelloworld:0.2.5`

## Run instructions
`docker run -d --rm --name flaskhelloworld -e APP_NAME=blue -p 5000:5000 sbwise/flaskhelloworld:0.2.5`

## Minikube
1. Download and install the minikube binary appropriate to your OS platform
   1. See https://github.com/kubernetes/minikube/releases
   1. For example, for Mac OS with M1 chip:  https://github.com/kubernetes/minikube/releases/download/v1.30.1/minikube-darwin-arm64.tar.gz
1. Run minikube `minikube start`
1. Deploy the kustomize:  `kubectl apply -k ./k8s`
   1. Alter the image in `./k8s/app.yaml` to the one you built following the build instructions
1. Create a port forward: `kubectl port-forward -n app service/flaskhelloworld 5000:5000`
1. Test the application in your web browser:  `http://localhost:5000/`
