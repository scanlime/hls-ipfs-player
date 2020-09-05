#!/bin/bash
# ./hls-ipfs.sh <hash>

set -e

# Inputs. Assumes we have one argument which is a hash of a directory containing
# a 'master.m3u8' list of resolutions, and further m3u8 files for each resolution.
# I've been using PeerTube's HLS files for this, which are encoded in fragmented mp4
# using byte ranges.

video_cid="$1"
video_m3u8="$video_cid/master.m3u8"
player_bundle="dist/main.js"

# PUT YOUR OWN SERVERS HERE OR IT WONT WORK.
# This is a list of multiaddrs, space separated.
# The client will choose one at random on startup.
#
# If you leave this blank, the js-ipfs library will use its default delegates, which
# are a pool of public servers. This probably won't work well enough for video streaming,
# we need a node that can reliably locate content.

ipfs_delegates="$ipfs_delegates /dns4/ipfs.diode.zone/tcp/443/wss/p2p/QmPjtoXdQobBpWa2yS4rfmHVDoCbom2r2SMDTUa1Nk7kJ5"

# Bootstrap servers, space separated. The client tries to connect to all of these, to locate
# peers. Any of the public libp2p or ipfs bootstrap or preload servers would work here.
# If the list is empty, the js-ipfs library uses its built-in list of public bootstrap servers.

ipfs_bootstrap="$ipfs_bootstrap /dns4/ams-1.bootstrap.libp2p.io/tcp/443/wss/p2p/QmSoLer265NRgSp2LA3dPaeykiS1J6DifTC88f5uVQKNAd"
ipfs_bootstrap="$ipfs_bootstrap /dns4/lon-1.bootstrap.libp2p.io/tcp/443/wss/p2p/QmSoLMeWqB7YGVLJN3pNLQpmmEk35v6wYtsMGLzSr5QBU3"
ipfs_bootstrap="$ipfs_bootstrap /dns4/sfo-3.bootstrap.libp2p.io/tcp/443/wss/p2p/QmSoLPppuBtQSGwKDZT2M73ULpjvfd3aZ6ha4oFGL1KrGM"
ipfs_bootstrap="$ipfs_bootstrap /dns4/sgp-1.bootstrap.libp2p.io/tcp/443/wss/p2p/QmSoLSafTMBsPKadTEgaXctDQVcqN88CNLHXMkTNwMKPnu"
ipfs_bootstrap="$ipfs_bootstrap /dns4/nyc-1.bootstrap.libp2p.io/tcp/443/wss/p2p/QmSoLueR4xBeUbY9WZ9xGUUxunbKWcrNFTDAadQJmocnWm"
ipfs_bootstrap="$ipfs_bootstrap /dns4/nyc-2.bootstrap.libp2p.io/tcp/443/wss/p2p/QmSoLV4Bbm51jM9C4gDYZQ9Cy3U6aXMJDAbzgu2fzaDs64"
ipfs_bootstrap="$ipfs_bootstrap /dns4/node0.preload.ipfs.io/tcp/443/wss/p2p/QmZMxNdpMkewiVZLMRxaNxUeZpDUb34pWjZ1kZvsd16Zic"
ipfs_bootstrap="$ipfs_bootstrap /dns4/node1.preload.ipfs.io/tcp/443/wss/p2p/Qmbut9Ywz9YEDrz8ySBSgWyJk41Uvm2QJPhwDJzJyGFsD6"
ipfs_bootstrap="$ipfs_bootstrap /dns4/node2.preload.ipfs.io/tcp/443/wss/p2p/QmV7gnbW5VTcJ3oyM2Xk1rdFBJ3kTkvxc87UFGsun29STS"
ipfs_bootstrap="$ipfs_bootstrap /dns4/node3.preload.ipfs.io/tcp/443/wss/p2p/QmY7JB6MQXhxHvq7dBDh4HpbH29v4yE9JRadAVpndvzySN"
ipfs_bootstrap="$ipfs_bootstrap $ipfs_delegates"

# HTTPS gateway. This is provided by cloudflare, and it's how we load the HTTP and JS.
# This could be replaced with any gateway that supports subdomains.

url_gateway=ipfs.cf-ipfs.com

# Optional ipfs cluster for pinning the resulting HTML and JS.
# export IPFS_CLUSTER_CTL="ssh user@host bin/ipfs-cluster-ctl"

##################################################################

# check the supplied path
ipfs cat $video_m3u8 > /dev/null

bundle_cid=$(ipfs add -Q $player_bundle)
html_cid=$(ipfs add -Q - << EOF
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1000.0, minimum-scale=1.0">
		<link rel="icon" href="data:,">
		<script src="https://$(ipfs cid base32 $bundle_cid).$url_gateway/"></script>
                <style>
			body {
				background: #000;
				margin: 0;
			}
			video {
				position: absolute;
				width: 100%;
				height: 100%;
				left: 0;
				top: 0;
			}
		</style>
	</head>
	<body>
		<video muted controls
			data-ipfs-src="$video_m3u8"
			data-ipfs-delegates="$ipfs_delegates"
			data-ipfs-bootstrap="$ipfs_bootstrap"
			></video>
	</body>
</html>
EOF
)

echo https://$(ipfs cid base32 $html_cid).$url_gateway

if [ -n "$IPFS_CLUSTER_CTL" ]; then
	$IPFS_CLUSTER_CTL pin add --name hls-player-$video_cid $html_cid >&2
	$IPFS_CLUSTER_CTL pin add --name hls-player-bundle $bundle_cid >&2
fi

