#!/usr/bin/env bash
set -eux

# Equivalent to GEANT4_INSTALL_EXAMPLES=ON in cmake/Modules/G4CMakeMain.cmake.
mkdir -p "${PREFIX}/share/Geant4-10.7.4"
cp -R "${SRC_DIR}/src/examples" "${PREFIX}/share/Geant4-10.7.4/examples"
find "${PREFIX}/share/Geant4-10.7.4/examples" \( -name CVS -o -name .svn \) -prune -exec rm -rf {} +
