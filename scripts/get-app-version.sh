#!/bin/bash

yq '
  .modules[]
  | select(.name == "saber")
  | .sources[]
  | select(.url == "*/saber.git")
  | .tag
' flatpak-flutter.yaml
exit $?
