#!/usr/bin/env bash
set -e
mkdir -p data/sample_images
cd data/sample_images

# USC‑SIPI textures (public domain for research/teaching)
base="http://sipi.usc.edu/database/preview/texture"
for id in {1..155}; do
    printf -v idx "%03d" "$id"
    url="$base/$idx/$idx.png"
    echo "Downloading $url"
    curl -sSf "$url" -o "$idx.png"
done
echo "Finished downloading textures."
