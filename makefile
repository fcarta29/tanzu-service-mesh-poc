build:
	TAG=`git rev-parse --short=8 HEAD`; \
	docker build --rm -f tanzu-service-mesh-poc.dockerfile -t tanzu-service-mesh-poc:$$TAG .; \
	docker tag tanzu-service-mesh-poc:$$TAG tanzu-service-mesh-poc:latest

clean:
	docker stop tanzu-service-mesh-poc
	docker rm tanzu-service-mesh-poc

rebuild: clean build

run:
	docker run --name tanzu-service-mesh-poc -v /var/run/docker.sock:/var/run/docker.sock -v $$PWD/scenarios:/scenarios -v $$PWD/config/kube.conf:/root/.kube/config -td tanzu-service-mesh-poc:latest
	docker exec -it tanzu-service-mesh-poc bash -l
demo: 
	docker run --name tanzu-service-mesh-poc -p 8080-8090:8080-8090 -v /var/run/docker.sock:/var/run/docker.sock -v $$PWD/scenarios:/scenarios -v $$PWD/config/kube.conf:/root/.kube/config -td tanzu-service-mesh-poc:latest
	docker exec -it tanzu-service-mesh-poc bash -l	
join:
	docker exec -it tanzu-service-mesh-poc bash -l

start:
	docker start tanzu-service-mesh-poc

stop:
	docker stop tanzu-service-mesh-poc

default: build
