FROM golang:1.27.4@sha256:5f1b98fa02fe396ebce2a0227a0e08309e11792915b9dd2e1f71053d7e7e6666 AS builder
WORKDIR /src

COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download && go mod verify

COPY ./main.go ./
COPY ./cmd ./cmd
COPY ./template ./template
COPY ./config ./config
COPY ./runner ./runner
COPY ./types ./types
COPY ./jsonpath ./jsonpath
COPY ./structutil ./structutil
COPY ./filesystem ./filesystem
COPY ./kustomize ./kustomize
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /cron-workflow-replicator .

FROM scratch
COPY --from=builder /cron-workflow-replicator /cron-workflow-replicator
USER 65532:65532
CMD ["/cron-workflow-replicator"]
