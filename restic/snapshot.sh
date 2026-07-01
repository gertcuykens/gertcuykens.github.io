#!/bin/zsh

sort_by_time=false
for arg in "$@"; do
  if [[ "$arg" == "--time" ]]; then
    sort_by_time=true
  fi
done

restic snapshots \
  --latest 1 \
  --group-by host,tags,paths \
  --json \
  | jaq --argjson sort_by_time "$sort_by_time" -r '
      [ "Time", "Host", "Tags", "Paths", "ID" ],
      [ "----", "----", "----", "-----", "--" ],
      (
        sort_by(
          if $sort_by_time then
            [.snapshots[0].time, .group_key.hostname, .group_key.tags, .group_key.paths]
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
            ($gk.tags | join(",")),
            ($gk.paths | join(",")),
            .short_id
          ]
      )
      | @tsv
    ' \
  | column -t -s $'\t'
