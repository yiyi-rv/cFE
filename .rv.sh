#!/bin/bash
PROJECT_DIR=`pwd`
JSON_OUT=`pwd`/errors.json
COMPILER="kcc -fissue-report=${JSON_OUT}"

# Prepare to build the project
rm -rf osal
git submodule init
git submodule update --recursive

cd osal/src/os/
ln -sf posix posix-ng

cd -
mkdir -p rv_build
cd rv_build

# Start to build project
cmake -DCMAKE_C_COMPILER=${COMPILER} -DENABLE_UNIT_TESTS=TRUE --build ../cfe
make -j `nproc` mission-all
cd native/osal/unit-tests/
make -j`nproc`

# Run tests
cd ${PROJECT_DIR}/rv_build/native/osal/tests
./bin-sem-flush-test
./bin-sem-test
./bin-sem-timeout-test
./count-sem-test
./file-api-test
./mutex-test
./osal-core-test
./queue-timeout-test
./symbol-api-test
./timer-test
cd ${PROJECT_DIR}/rv_build/native/osal/unit-tests
./oscore-test/osal_core_UT
./osnetwork-test/osal_network_UT
./osloader-test/osal_loader_UT
./osfile-test/osal_file_UT
./osfilesys-test/osal_filesys_UT
./oscore-test/osal_core_UT

# Upload report
## TODO