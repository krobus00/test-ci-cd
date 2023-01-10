FROM golang:1.18.1-alpine as base
WORKDIR /builder
ENV GO111MODULE=on CGO_ENABLED=0
COPY go.mod go.sum /builder/
RUN go mod download
COPY . .
RUN go build \
  -ldflags "-s -w" \
  -o /builder/main /builder/cmd/app/main.go

FROM alpine:3.8
WORKDIR /app
COPY --from=base /builder/main main
EXPOSE 1323
CMD ["/app/main"]
