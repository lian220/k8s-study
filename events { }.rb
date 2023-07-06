events { }
stream {
    upstream stream_backend{
        least_conn;
        server 192.168.0.23:6443;
        server 192.168.0.22:6443;
        server 192.168.0.21:6443;
    }

    server {
        listen          6443;
        proxy_pass      stream_backend;
        proxy_timeout   300s;
        proxy_connect_timeout 1s;

    }
}

docker stop proxy
docker rm proxy
docker ps

docker run --name proxy -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf:ro --restart=always -p 6443:6443 -d nginx
curl 192.168.0.19:6443
sha256:08bc36ad52474e528cc1ea3426b5e3f4bad8a130318e3140d6cfe29c8892c7ef

kubeadm init --control-plane-endpoint "node5:6443" --upload-certs

master
kubeadm join node5:6443 --token ajytee.dq1gjh69z1wi80ai \
        --discovery-token-ca-cert-hash sha256:477838c06e2117f0dac621129f08989c1c587c136f4ed41cfa2bc8f0a9ca767d \
        --control-plane --certificate-key 6d101ecc52ea17b660051d9ed7bc610896711d955e5b4a676b52afe9536846c2

node
kubeadm join node5:6443 --token ajytee.dq1gjh69z1wi80ai \
--discovery-token-ca-cert-hash sha256:477838c06e2117f0dac621129f08989c1c587c136f4ed41cfa2bc8f0a9ca767d


mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

2. Initialize cluster networking:

 kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml


 3. (Optional) Create an nginx deployment:

 kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml