#!/bin/zsh
docker stop jaeger
docker container rm -v jaeger
docker pull jaegertracing/jaeger

docker run --name jaeger --restart unless-stopped -d \
  -p 127.0.0.1:4317:4317 \
  -p 127.0.0.1:5778:5778 \
  -p 127.0.0.1:8888:8888 \
  -p 127.0.0.1:8890:8890 \
  -p 127.0.0.1:13133:13133 \
  -p 127.0.0.1:16686:16686 \
  -v /root/system/jaeger.yml:/jaeger/config.yaml \
  --init jaegertracing/jaeger --config /jaeger/config.yaml

docker exec jaeger /cmd/jaeger/jaeger-linux validate --config /jaeger/config.yaml
curl http://localhost:13133/status

# docker run --rm -v /root/system/jaeger.yml:/jaeger/config.yaml jaegertracing/jaeger validate --config /jaeger/config.yaml
# otelcol validate --config jaeger.yml

# curl -sSLO https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.125.0/otelcol-contrib_0.125.0_linux_amd64.tar.gz
# curl -sSLO https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.125.0/otelcol_0.125.0_linux_amd64.tar.gz

# 4317 OTLP/gRPC
# 5778 Jaeger Sampling
# 8888 Metric exporter
# 8890 Jaeger Metric exporter
# 16686 Jaeger UI
# 13133 Jeager health check

# --health-cmd='curl -sf "http://localhost:13133/status" || exit 1'\
# --health-interval=6s \
# --health-timeout=3s \
# --health-retries=1 \

