FROM golang:alpine as build

ENV AGENT_HOST localhost
ENV AGENT_PORT 6831

RUN apk add --no-cache \
      git \
      build-base

RUN go get github.com/jaegertracing/jaeger

WORKDIR /go/src/github.com/jaegertracing/jaeger

RUN make install

WORKDIR /go/src/github.com/jaegertracing/jaeger/examples/hotrod

RUN go build -o /usr/local/bin/hotrod ./main.go

FROM alpine

RUN apk add --no-cache \
      socat

COPY --from=build /usr/local/bin/hotrod /root/hotrod/hotrod
COPY --from=build /go/src/github.com/jaegertracing/jaeger/examples/hotrod/services/frontend/web_assets/index.html /root/hotrod/services/frontend/web_assets/index.html

RUN chmod +x /root/hotrod/hotrod

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
