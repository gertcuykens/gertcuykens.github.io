#!/bin/zsh

sort_by="name"
for arg in "$@"; do
  if [[ "$arg" == "--time" ]]; then
    sort_by="time"
  elif [[ "$arg" == "--size" ]]; then
    sort_by="size"
  fi
done

restic snapshots \
  --latest 1 \
  --group-by host,tags,paths \
  --json \
  --no-lock \
  | jaq --arg sort_by "$sort_by" -r '
      [ "Time", "Host", "Tags", "Paths", "Size", "ID" ],
      [ "----", "----", "----", "-----", "----", "--" ],
      (
        sort_by(
          if $sort_by == "time" then
            [.snapshots[0].time, .group_key.hostname, .group_key.tags, .group_key.paths]
          elif $sort_by == "size" then
            [-(.snapshots | map(.summary.total_bytes_processed // 0) | add), .group_key.hostname]
          else
            [.group_key.hostname, .group_key.tags, .group_key.paths]
          end
        )
        | .[]
        | .group_key as $gk
        | .snapshots[]
        | [
            (.time[0:19] | sub("T"; " ")),
            $gk.hostname,
            (if $gk.tags then $gk.tags | join(",") else "" end),
            ($gk.paths | join(",")),
            ((((.summary.total_bytes_processed // 0) / 1024 / 1024 / 1024) * 100 | round / 100) | tostring),
            .short_id
          ]
      )
      | @tsv
    ' \
  | column -t -s $'\t'
