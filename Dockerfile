FROM --platform=$BUILDPLATFORM golang:1.21.3 AS build

ARG TARGETOS
ARG TARGETARCH
ARG LIBRDKAFKA_VERSION=2.3.0

WORKDIR /home/app

RUN git clone --branch v${LIBRDKAFKA_VERSION} https://github.com/confluentinc/librdkafka && \
    cd librdkafka && \
    ./configure --prefix /usr && \
    make && make install

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,source=./go.mod,target=./go.mod \
    --mount=type=bind,source=./go.sum,target=./go.sum \
    go mod download

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=bind,target=. \
    GOOS=$TARGETOS GOARCH=$TARGETARCH go build \
    --ldflags '-linkmode external -extldflags "-static"' \
    -o /bin/server main.go

FROM gcr.io/distroless/base

COPY --from=build /bin/server /bin/

CMD [ "/bin/server" ]
