#!/bin/sh -e

CURRENT_FILE=alpine-vagrant-base.iso

help() {
	echo "Usage: ./build <version> [arch=x86_64]"
	exit 1
}

[ -z "$1" ] && help
version=${1}
arch=${2:-x86_64}

filename=alpine-${version}-${arch}.iso
url=http://wiki.alpinelinux.org/cgi-bin/dl.cgi/v3.1/releases/x86_64/${filename}
[ -f "$filename" ] || wget ${url}
[ -f "${filename}.asc" ] || wget ${url}.asc
gpg --verify ${filename}.asc

ln -fs ${filename} ${CURRENT_FILE}
packer-io build alpine.json
vagrant box add --force alpine64 build/alpine-latest-amd64.box
