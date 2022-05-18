FROM mcr.microsoft.com/dotnet/sdk:6.0.201 as builder
WORKDIR /app

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0.3-alpine3.15-amd64
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.8 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
WORKDIR /app

COPY --from=builder /cartservice .

ENV ASPNETCORE_URLS http://*:7070

ENTRYPOINT ["/app/cartservice"]
