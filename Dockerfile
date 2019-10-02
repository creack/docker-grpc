FROM golang:1.13

RUN apt-get update && apt-get -y install unzip && apt-get clean

# Install protobuf.
ENV PB_VER 3.9.0
ENV PB_CHECKSUM 15e395b648a1a6dda8fd66868824a396e9d3e89bc2c8648e3b9ab9801bea5d55
ENV PB_URL https://github.com/google/protobuf/releases/download/v${PB_VER}/protoc-${PB_VER}-linux-x86_64.zip

RUN mkdir -p /tmp/protoc && \
    curl -L ${PB_URL} > /tmp/protoc/protoc.zip && \
    cd /tmp/protoc && \
    echo "${PB_CHECKSUM}  protoc.zip" | sha256sum -c - && \
    unzip protoc.zip && \
    cp /tmp/protoc/bin/protoc /usr/local/bin && \
    cp -R /tmp/protoc/include/* /usr/local/include && \
    chmod go+rx /usr/local/bin/protoc && \
    cd /tmp && \
    rm -r /tmp/protoc
# !Install protobuf.


ENV GO111MODULE=on

# Install grpc & protoc-gen-go.
RUN go get google.golang.org/grpc@v1.24.0 && \
    go get github.com/golang/protobuf/protoc-gen-go@v1.3.2

# Install grpc-gateway & gen-swagger.
ENV GRPCGW_VER 1.11.2
RUN go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v${GRPCGW_VER} && \
    go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@v${GRPCGW_VER} && \
    mkdir -p /go/src/github.com/grpc-ecosystem && \
    ln -s /go/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v${GRPCGW_VER} /go/src/github.com/grpc-ecosystem/grpc-gateway

# Install go-proto-validators.
ENV GOVALIDATORS_VER 0.2.0
RUN go get github.com/mwitkow/go-proto-validators/protoc-gen-govalidators@v${GOVALIDATORS_VER} && \
    mkdir -p /go/src/github.com/mwitkow && \
    ln -s /go/pkg/mod/github.com/mwitkow/go-proto-validators@v${GOVALIDATORS_VER} /go/src/github.com/mwitkow/go-proto-validators

# Fix permissions to allow for non-root users.
RUN find /go -type d -exec chmod 755 {} \; && find /go/pkg -type f -exec chmod 644 {} \;

ENTRYPOINT ["protoc", "-I.", "-I/usr/local/include", "-I/go/src", "-I/go/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis"]
