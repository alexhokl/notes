reg_name='kind-registry'
reg_port='5000'
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"
if [ "${running}" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi
curl -o kind-cluster.yml -sSL https://raw.githubusercontent.com/alexhokl/notes/master/yaml/kind-cluster.yml
kind create cluster --config=kind-cluster.yml
docker network connect "kind" "${reg_name}" || true
kubectl apply -f https://raw.githubusercontent.com/alexhokl/notes/master/yaml/kind-local-registry-config.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

