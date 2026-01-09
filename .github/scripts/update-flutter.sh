#!/bin/bash

set -e

if [ ! -d "saber" ]; then
  echo "You must clone saber-notes/saber first!"
  exit 1
fi

export FLUTTER_COMMIT=$(git -C saber rev-parse @:./submodules/flutter)
export FLUTTER_VERSION=$(git -C saber ls-remote --tags https://github.com/flutter/flutter.git \
  | awk -v c="$FLUTTER_COMMIT" '$1 == c { sub(/refs\/tags\//, "", $2); print $2 }')
echo "Found Flutter version: $FLUTTER_VERSION ($FLUTTER_COMMIT)"

yq -i '
  with(.modules[]; 
    select(.name == "saber") 
    | with(.sources[]; 
        select(.url == "*/flutter.git")
        | .tag = strenv(FLUTTER_VERSION)
        | .commit = strenv(FLUTTER_COMMIT)
    )
  )
' flatpak-flutter.yaml

exit $?
