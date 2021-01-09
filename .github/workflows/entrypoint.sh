#!/bin/bash
# build wheels
set -e

# Hack
# see here:
# https://github.com/RalfG/python-wheels-manylinux-build/issues/26
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

# Build the wheels
for PYVER in cp35-cp35m cp36-cp36m cp37-cp37m cp38-cp38 cp39-cp39; do
  # build the wheels
  /opt/python/$PYVER/bin/pip wheel /github/workspace -w /github/workspace/wheels || { echo "Failed while buiding $PYVER wheel"; exit 1; }
done

# fix the wheels (bundles libs)
for wheel in /github/workspace/wheels/*64.whl; do
  auditwheel repair "$wheel" --plat manylinux1_x86_64 -w /github/workspace/manylinux1-wheels
done

echo "Built wheels:"
ls /github/workspace/manylinux1-wheels
