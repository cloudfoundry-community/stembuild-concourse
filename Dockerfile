ARG GOVC_VERSION=v0.20.0

FROM ubuntu AS build
RUN apt-get update && apt-get -y install curl && rm -rf /var/cache/apt/*
RUN curl -L https://github.com/vmware/govmomi/releases/download/${GOVC_VERSION:-v0.20.0}/govc_linux_amd64.gz | gunzip > /usr/local/bin/govc && chmod +x /usr/local/bin/govc

FROM ubuntu
COPY --from=build /usr/local/bin/govc /usr/local/bin/govc
