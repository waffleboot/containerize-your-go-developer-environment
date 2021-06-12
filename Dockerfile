# syntax = docker/dockerfile:1-experimental
FROM --platform=${BUILDPLATFORM} golang:1.14.3-alpine AS build
ARG TARGETOS
ARG TARGETARCH
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .
RUN go mod download
COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/example .
FROM scratch AS bin-unix
COPY --from=build /out/example /
FROM bin-unix AS bin-linux
FROM bin-unix AS bin-darwin
FROM scratch  AS bin-windows
COPY --from=build /out/example /example.exe
FROM bin-${TARGETOS} AS bin
