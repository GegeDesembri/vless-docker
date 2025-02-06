#!/bin/bash

# Core Parameter
username="gegedesembri"
imagename="xray-vless"
version="1.6.3"
version_tag="${username}/${imagename}:${version}"
latest_tag="${username}/${imagename}:latest"
use_builder="multi-builder"
target_platform_list="linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x"

# Function Block
function buildx_sequence(){
	buildxer="$1"
	target_platform="$2"
	tag_name="$3"

	docker buildx build \
		--network="host" \
		--builder="${buildxer}" \
		--platform="${target_platform}" \
		--tag="${latest_tag}" \
		--tag="${tag_name}" .
}

function buildx_sequences(){
	platform_list="$(echo -n "$1" | sed 's/^,//g;s/,$//g')"
	
	sum1_platform="${platform_list//[^,]}"
	sum2_platform="$(echo "${#sum1_platform}+1" | bc)"

	seq ${sum2_platform} | while read seq_platform; do
		echo -n "${platform_list}" | cut -d ',' -f 1-${seq_platform}
	done | while read platform; do
		current_platform="$(echo -n "${platform}" | rev | cut -d ',' -f 1 | rev)"
		echo -e "SEQ - ${platform}"
		echo -e "START - ${current_platform} ${version_tag}"
		buildx_sequence "${use_builder}" "${platform}" "${version_tag}"
		echo -e "DONE - ${platform} ${version_tag}"
	done
}

function buildx_push(){
	buildxer="$1"
	push_platform="$(echo -n "$2" | sed 's/^,//g;s/,$//g')"
	tag_name="$3"

	docker buildx build \
		--push \
		--network="host" \
		--builder="${buildxer}" \
		--platform="${push_platform}" \
		--tag="${latest_tag}" \
		--tag="${tag_name}" .
}

# Building
buildx_sequences "${target_platform_list}"
buildx_push "${use_builder}" "${target_platform_list}" "${version_tag}"
