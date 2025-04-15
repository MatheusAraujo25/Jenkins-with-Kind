.DEFAULT_GOAL := up


pre:
	# ref:
	# https://kind.sigs.k8s.io/docs/user/loadbalancer/#installing-metallb-using-default-manifests
	@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
	@kubectl wait --namespace metallb-system \
		--for=condition=ready pod \
		--selector=app=metallb \
		--timeout=120s
	@kubectl apply -f manifests/

att-helm:
	@helmfile apply

helm: att-helm passwd

create:
	@kind create cluster --config config.yaml --image "kindest/node:v1.30.0"

up: create pre helm

passwd:
	@echo "All credentials:"
	@echo ""
	@echo "Jenkins name:"
	@kubectl get secret -n jenkins jenkins -ojson | jq -r '.data."jenkins-admin-user"' | base64 -d 
	@echo " "
	@echo "Password:"
	@kubectl get secret -n jenkins jenkins -ojson | jq -r '.data."jenkins-admin-password"' | base64 -d
	@echo "\n"
	@echo "gitea name: gitea_admin"
	@echo "Password: r8sA8CPHD9!bt6d"
	@echo "\n"
	@echo "Habor name: admin"
	@echo "Habor password: Harbor12345"
	@echo "\n"
	@echo "Sonarqube name: admin"
	@echo "Sonarqueb password: Sonarqube12345!"

destroy:
	@kind delete clusters kind

