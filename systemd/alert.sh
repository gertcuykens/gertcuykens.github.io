#! /bin/zsh

send_alert() {
  local content="$1"
  local i="$2"
  printf "$content $i\n"
  curl -X POST -H "Content-Type: application/json" -d @- http://localhost:9093/api/v2/alerts <<EOF
[
  {
    "status":"firing",
    "labels": {
      "alertname": "HighCPUUsage",
      "job": "test",
      "instance": "test",
      "severity": "critical",
      "group": "test",
      "counter":"$i"
    },
    "annotations": {
      "summary": "CPU usage is above 90%",
      "description": "The CPU usage on the test job has exceeded 90% threshold.",
      "content": "$content"
    },
    "startsAt": "2025-01-01T01:00:00Z",
    "endsAt": "2026-01-01T01:00:00Z",
    "generatorURL":"https://prometheus.../query?g0.expr=up+%3D%3D+0&g0.tab=1",
    "fingerprint":"1"
  }
]
EOF
}

send_alert "Alert Test $(date)" $1

exit

i=0
while true; do
  send_alert "Alert Test $(date)" "$i"
  ((i++))
  sleep 2
done

