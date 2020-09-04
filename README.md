# hls-ipfs-player

Simple HLS player container for serving videos over IPFS

I was experimenting with doing a PeerTube-compatible storage layer that uses IPFS for clustering and peer-to-peer, and here we are. It's just a sandbox for performance testing and bugfixing the relevant bleeding-edge pieces of js-ipfs really.

- [Long isopod video, 1080p max](https://bafybeigybaexxzdxrjc4m77n6xbuoemtnxvplnvughwdrnerxy57y7xqxi.ipfs.cf-ipfs.com)
- [Short shader video, 2160p max](https://bafybeibyi3jqkxxwmt6wqscz4u3qjqn6xn4wqr3djgwzs77hm6biyjrk5y.ipfs.cf-ipfs.com/)

This is currently using my [fork of hlsjs-ipfs-loader](https://github.com/scanlime/hlsjs-ipfs-loader) to fix byte range loading, there is a [pull request](https://github.com/moshisushi/hlsjs-ipfs-loader/pull/18).
