#!/usr/bin/env bash
set -eux

declare -a CMAKE_PLATFORM_FLAGS

if [[ "${target_platform}" == osx-* ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DGEANT4_USE_OPENGL_X11=OFF)
  CMAKE_PLATFORM_FLAGS+=(-DGEANT4_USE_RAYTRACER_X11=OFF)
else
  CMAKE_PLATFORM_FLAGS+=(-DGEANT4_USE_OPENGL_X11=ON)
  CMAKE_PLATFORM_FLAGS+=(-DGEANT4_USE_RAYTRACER_X11=ON)
fi

# GEANT4_USE_QT is set per variant by the recipe.
if [[ "${GEANT4_USE_QT}" == "ON" ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DQT_QMAKE_EXECUTABLE="${PREFIX}/bin/qmake")
fi

test -f "${SRC_DIR}/src/CMakeLists.txt"

cmake \
    -B ./geant4-build \
    -S "${SRC_DIR}/src" \
    -G Ninja \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON                                   \
    -DGEANT4_BUILD_CXXSTD=17                                 \
    -DGEANT4_BUILD_MULTITHREADED=ON                          \
    -DGEANT4_BUILD_TLS_MODEL=global-dynamic                  \
    -DGEANT4_INSTALL_DATA=OFF                                \
    -DGEANT4_INSTALL_DATADIR="${PREFIX}/share/Geant4/data"   \
    -DGEANT4_INSTALL_EXAMPLES=OFF                            \
    -DGEANT4_INSTALL_PACKAGE_CACHE=OFF                       \
    -DGEANT4_USE_FREETYPE=ON                                 \
    -DGEANT4_USE_GDML=ON                                     \
    -DGEANT4_USE_HDF5=OFF                                    \
    -DGEANT4_USE_QT="${GEANT4_USE_QT}"                       \
    -DGEANT4_USE_PYTHON=OFF                                  \
    -DGEANT4_USE_SYSTEM_CLHEP=ON                             \
    -DGEANT4_USE_SYSTEM_EXPAT=ON                             \
    -DGEANT4_USE_SYSTEM_ZLIB=ON                              \
    "${CMAKE_PLATFORM_FLAGS[@]}"

cmake --build ./geant4-build --parallel "${CPU_COUNT:-2}"
cmake --install ./geant4-build

# Print the contents of geant4.sh in case of problems
echo "Contents of ${PREFIX}/bin/geant4.sh is"
cat "${PREFIX}/bin/geant4.sh"

# Remove the geant4.(c)sh scripts and replace with a dummy version
for suffix in sh csh; do
  rm "${PREFIX}/bin/geant4.${suffix}"
  cp "${RECIPE_DIR}/geant4-setup" "${PREFIX}/bin/geant4.${suffix}"
  chmod +x "${PREFIX}/bin/geant4.${suffix}"
done
