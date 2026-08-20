#!/usr/bin/env bash
set -eux

geant4-config --version
geant4-config --prefix
geant4-config --libs
geant4-config --cflags

# Check the build matches the variant it claims to be.
if [[ "${GEANT4_USE_QT}" == "ON" ]]; then
  test "$(geant4-config --has-feature qt)" = "yes"
else
  test "$(geant4-config --has-feature qt)" = "no"
fi

test "$(geant4-config --has-feature multithreading)" = "yes"
test "$(geant4-config --has-feature hdf5)" = "yes"
test "$(geant4-config --has-feature gdml)" = "yes"

# Check every dataset Geant4 was configured against is installed at the version
# it expects. `geant4-config --datasets` prints "<NAME> <ENVVAR> <PATH>" with the
# version baked in at configure time; the conda geant4-data-* packages point
# their env var at their own directory. Comparing the two catches a
# geant4-data-* pin that has drifted from what this Geant4 release wants.
# (--check-datasets is no use here: it looks for Geant4's own G4EMLOW8.8 style
# paths, while the conda packages use EMLOW8.8 and the env vars.)
geant4-config --datasets > datasets.txt
cat datasets.txt
datasets_ok=1
while read -r ds_name ds_envvar ds_path; do
  expected=$(basename "${ds_path}" | grep -oE '[0-9]+(\.[0-9]+)*$')
  installed_path="${!ds_envvar:-}"
  if [ -z "${installed_path}" ]; then
    echo "ERROR: ${ds_name}: ${ds_envvar} is not set, geant4-data-${ds_name} missing from run deps?"
    datasets_ok=0
    continue
  fi
  if [ ! -d "${installed_path}" ]; then
    echo "ERROR: ${ds_name}: ${ds_envvar}=${installed_path} is not a directory"
    datasets_ok=0
    continue
  fi
  installed=$(basename "${installed_path}" | grep -oE '[0-9]+(\.[0-9]+)*$')
  if [ "${expected}" != "${installed}" ]; then
    echo "ERROR: ${ds_name}: Geant4 expects ${expected}, but ${ds_envvar} points at ${installed}"
    datasets_ok=0
  fi
done < datasets.txt
test "${datasets_ok}" -eq 1

cmake -G Ninja -B test-build -S test_cmake ${CMAKE_ARGS:-}
cmake --build test-build
./test-build/geant4-conda-test
