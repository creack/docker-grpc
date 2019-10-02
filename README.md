# docker-grpc

Dockerfile with protobuf, grpc and protoc-gen-go installed.

# Aliases

```sh
# Docker run with current user mounted in.
alias udockerrun='docker run --rm --user $(id -u):$(id -g) -v $HOME:$HOME -w $(pwd) -e GOPATH=$HOME/go:/go'

# Also works with 'creack/grpc:latest'.
alias protoc='udockerrun creack/grpc:go1.13-protobuf3.9.0-grpc1.24.0-protocgengo1.3.2'

alias gprotoc='protoc --go_out=plugins=grpc:.'
alias gvprotoc='gprotoc --govalidators_out=.'
alias gwprotoc='protoc --grpc-gateway_out="logtostderr=true:."'
alias sprotoc='protoc --swagger_out="logtostderr=true:."'
```

# Base

Based on https://github.com/grpc/grpc-docker-library which doesn't seem to be maintained.

# Content

Includes all the required tools to generate go grpc files from protobuf:
    - protoc
    - protoc-gen-go
    - grpc

Also includes grpc-ecosystem and validation tools:
    - protoc-gen-grpc-gateway
    - protoc-gen-swagger
    - protoc-gen-govalidators
