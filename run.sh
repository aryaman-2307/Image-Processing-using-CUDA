#!/usr/bin/env bash
set -e
echo "Building..."
build_dir="build"
cmake -S . -B "$build_dir" -DCMAKE_BUILD_TYPE=Release
cmake --build "$build_dir" -- -j"$(nproc)"

echo "🏃 Running demo on sample dataset..."
"$build_dir/bin/batch_processor" \
  --input data/sample_images \
  --output docs/execution-artifacts/before_after \
  --filter median --radius 3 | tee docs/execution-artifacts/log.txt
