#!/bin/zsh
set -eEuxo pipefail

err() {
    if [ $? -ne 0 ]; then
        echo "Error: Operation failed, exiting script."
        exit 1
    fi
}

err

