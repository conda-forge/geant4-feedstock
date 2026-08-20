#!/usr/bin/env bash
set -eux

# Mirrors what GEANT4_INSTALL_EXAMPLES=ON does in
# cmake/Modules/G4CMakeMain.cmake, but as its own package so that `geant4`
# itself does not carry ~95 MB of example sources.
mkdir -p "${PREFIX}/share/Geant4"
cp -R "${SRC_DIR}/src/examples" "${PREFIX}/share/Geant4/examples"
find "${PREFIX}/share/Geant4/examples" \( -name CVS -o -name .svn \) -prune -exec rm -rf {} +
