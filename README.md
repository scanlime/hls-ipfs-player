# hls-ipfs-player

Simple HLS player container for serving videos over IPFS

I was experimenting with doing a PeerTube-compatible storage layer that uses IPFS for clustering and peer-to-peer, and here we are. It's just a sandbox for performance testing and bugfixing the relevant bleeding-edge pieces of js-ipfs really.

This is currently using my [fork of hlsjs-ipfs-loader](https://github.com/scanlime/hlsjs-ipfs-loader) to fix byte range loading, there is a [pull request](https://github.com/moshisushi/hlsjs-ipfs-loader/pull/18).

- [Sample: Long isopod video, 1080p max](https://bafybeiczkxwx56gfqgplfqzbacarexin5pbjq3z2ktow33lk253kyp4pye.ipfs.cf-ipfs.com)
- [Sample: Short shader video, 2160p max](https://bafybeigp56xg53ylpiv4v274rxuusvt43lne7dar5xlnq67d4jy64bcn24.ipfs.cf-ipfs.com)
