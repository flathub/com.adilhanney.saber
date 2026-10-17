#!/bin/bash
# flatpak-flutter isn't updated often, and sometimes we need a fixed version.
#
# This does essentially the same as .github/workflows/update.yml,
# but with a local copy of flatpak-flutter.
#
# Your fork of flatpak-flutter is assumed to be at ../flatpak-flutter/

flatpak install flathub org.flathub.flatpak-external-data-checker
flatpak run org.flathub.flatpak-external-data-checker flatpak-flutter.yaml --edit

rm -rf generated
../flatpak-flutter/flatpak-flutter.py flatpak-flutter.yaml
