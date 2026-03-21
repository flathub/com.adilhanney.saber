#!/bin/bash

docker run --rm --pull=always -v "$PWD":/usr/src/flatpak -u `id -u`:`id -g` theappgineer/flatpak-flutter:latest flatpak-flutter.yaml
