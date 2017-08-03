FROM ubuntu:17.04

RUN mkdir -p /cfssl/ca
ADD cfssl/ca/ca-config.json /cfssl/ca/ca-config.json
ADD cfssl/ca/ca-csr.json /cfssl/ca/ca-csr.json

RUN mkdir cfssl/etcdsandbox1
ADD cfssl/etcdsandbox1/server.json /cfssl/etcdsandbox1/server.json

RUN mkdir /cfssl/etcdsandbox1-client
ADD cfssl/etcdsandbox1-client/client.json /cfssl/etcdsandbox1-client/client.json


RUN apt-get update && apt-get -y install curl etcd nano vim && rm -rf /var/lib/apt/lists/*
RUN curl -s -L --insecure -o /bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && curl -s -L --insecure  -o /bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && chmod +x /bin/cfssl && chmod +x /bin/cfssljson
