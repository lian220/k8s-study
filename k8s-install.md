## K8s 설치

1. vagrant 설치
    - vagrant는 가상머신을 여러대 설치하기 위해 필요


[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR CRI]: container runtime is not running: output: E0628 05:25:03.328678    3977 remote_runtime.go:616] "Status from runtime service failed" err="rpc error: code = Unavailable desc = connection error: desc = \"transport: Error while dialing dial unix /var/run/containerd/containerd.sock: connect: no such file or directory\""
time="2023-06-28T05:25:03Z" level=fatal msg="getting status of runtime: rpc error: code = Unavailable desc = connection error: desc = \"transport: Error while dialing dial unix /var/run/containerd/containerd.sock: connect: no such file or directory\""
, error: exit status 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher

docker 버전 및 제대로 설치 안되어 있을 가능성 있음.


[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR CRI]: container runtime is not running: output: time="2020-11-25T12:58:32Z" level=fatal msg="getting status of runtime failed: rpc error: code = Unimplemented desc = unknown service runtime.v1alpha2.RuntimeService"
, error: exit status 1

containerd 의 cir 설정이 false로 되어 있을수도 있어서 삭제해주는방법이 있다.
1. etc/containered/config.toml 삭제
2. systemctl restart containerd

이닛 하기전
1. kubeadm config images pull

Installing a Pod network add-on
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml


### 토큰 인증문제
error execution phase preflight: couldn't validate the identity of the API Server: Get "https://10.0.2.15:6443/api/v1/namespaces/kube-public/configmaps/cluster-info?timeout=10s": dial tcp 10.0.2.15:6443: connect: connection refused
To see the stack trace of this error execute with --v=5 or higher

kubeadm init  --apiserver-advertise-address=192.168.1.10 --ignore-preflight-errors=NumCPU --pod-network-cidr=192.168.0.0/16

1. 토큰 확인
kubeadm token list
2. 기존 토큰 삭제 (위 list에서 나온 TOKEN을 넣어줌)
kubeadm token delete {TOKEN}
3. 새 토큰 create
kubeadm token create --print-join-command
4. 새 토큰 확인
kubeadm token list

공개키 설정
openssl x509 -in /etc/kubernetes/pki/ca.crt -pubkey -noout |
openssl pkey -pubin -outform DER |
openssl dgst -sha256

kubeadm join 192.168.1.10:6443 --token {토큰명}
--discovery-token-ca-cert-hash sha256:{pkey}
q9gmry.lsz2o5gmxx23a148
626ee974ae548717fe19df56d8a1defa0d604c60fd39640ec38f488e01ea8df1

kubeadm reset --kubeconfig /etc/kubernetes/admin.conf --cri-socket /var/run/containerd/containerd.sock
$ sudo kubeadm reset
$ sudo systemctl restart kubelet
$ sudo reboot

https://bono915.tistory.com/entry/Kubernetes-VirtualBox-Node-INTERNAL-IP-%EC%84%A4%EC%A0%95-%EB%B0%A9%EB%B2%95

컨테이너 접속 설정 (internal-ip 변경해야 접속 가능)
1. 순서 확인
vi /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
2. 파일위치
vi /etc/sysconfig/kubelet
3. 수정
Environment="KUBELET_EXTRA_ARGS=--node-ip=192.168.1.11"
4. 재시작
systemctl daemon-reload && systemctl restart kubelet


멀티 마스터
1. 컨테이너 runtime 설치 (Docker)
https://docs.docker.com/engine/install/centos/#install-using-the-repository

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo docker run hello-world

## 2. kubeadm install
1. systemctl stop firewalld && systemctl disable firewalld
2. swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab
3. Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
4. kubeadm, kubelet, kubectl 설치





