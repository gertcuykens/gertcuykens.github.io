#!/bin/zsh

restic snapshots \
  --latest 1 \
  --group-by host,tags,paths \
  --json \
  | jaq -r '
      [ "Time", "Host", "Tags", "Paths", "ID" ],
      [ "----", "----", "----", "-----", "--" ],
      (
        sort_by([.group_key.hostname, .group_key.tags, .group_key.paths])
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
