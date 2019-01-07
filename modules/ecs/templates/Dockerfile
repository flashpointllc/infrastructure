FROM golang:1.9-alpine3.7
ARG health_check_path
ARG health_check_port
ENV HEALTHCHECK_PATH=$health_check_path
ENV HEALTHCHECK_PORT=$health_check_port
EXPOSE $HEALTHCHECK_PORT

RUN apk update && apk upgrade && apk add git
WORKDIR /go
ADD main.go ./


RUN env GOOS=linux GOARCH=amd64 HEALTHCHECK_PATH=$HEALTHCHECK_PATH HEALTHCHECK_PORT=$HEALTHCHECK_PORT go build -o server
RUN cp server /go/bin/
CMD ["/go/bin/server"]
