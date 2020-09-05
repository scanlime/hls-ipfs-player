#!/bin/bash

set -e

# Example HTML

hls_cid=QmVLAuxsFgCkDWE5kd5ZPthBm4vaksTe4YEmH266wB5ZW8
url=`examples/hls-ipfs.sh $hls_cid`
(echo // $url; curl $url) > examples/index.html

# Example links in the README

mv README.md README.md.bak
(
  egrep -v "Sample:" README.md.bak
  echo "- [Sample: Long isopod video, 1080p max](`examples/hls-ipfs.sh QmVLAuxsFgCkDWE5kd5ZPthBm4vaksTe4YEmH266wB5ZW8 | head -n1`)"
  echo "- [Sample: Short shader video, 2160p max](`examples/hls-ipfs.sh QmNuNr3NQqQ2xWfZueHFR3zzAUknYYA7MTto9Em1pStEEX | head -n1`)"
) > README.md
