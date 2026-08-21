#!/usr/bin/env bash
set -eux

# Equivalent to GEANT4_INSTALL_EXAMPLES=ON in cmake/Modules/G4CMakeMain.cmake.
mkdir -p "${PREFIX}/share/Geant4"
cp -R "${SRC_DIR}/src/examples" "${PREFIX}/share/Geant4/examples"
find "${PREFIX}/share/Geant4/examples" \( -name CVS -o -name .svn \) -prune -exec rm -rf {} +
# Deliberately keeps the source permissions. GEANT4_INSTALL_EXAMPLES=ON drops
# the executable bit from the 34 scripts upstream ships as executable, because
# its install(DIRECTORY) call omits USE_SOURCE_PERMISSIONS.
