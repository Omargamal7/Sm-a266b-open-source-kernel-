#!/bin/bash
set -euo pipefail

# Resolve the Android build tree root relative to this script.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Define expected prebuilt locations in an Android build tree.
CLANG_VERSION="clang-r450784d"
CLANG_PREBUILT_DIR="${ROOT_DIR}/prebuilts/clang/host/linux-x86/${CLANG_VERSION}"
BUILDTOOLS_PREBUILT_BIN="build/kernel/build-tools/path/linux-x86"
BUILDTOOLS_SYSROOT="${ROOT_DIR}/build/kernel/build-tools/sysroot"
KERNEL_BUILD_TOOLS_PREBUILT="${ROOT_DIR}/prebuilts/kernel-build-tools/linux-x86"

# Verify required prebuilts exist before continuing.
if [[ ! -d "${CLANG_PREBUILT_DIR}/bin" ]]; then
  echo "Missing clang prebuilts at: ${CLANG_PREBUILT_DIR}/bin" >&2
  exit 1
fi
if [[ ! -d "${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}" ]]; then
  echo "Missing build-tools path at: ${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}" >&2
  exit 1
fi
if [[ ! -x "${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}/dtc" ]]; then
  echo "Missing dtc at: ${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}/dtc" >&2
  exit 1
fi
if [[ ! -d "${KERNEL_BUILD_TOOLS_PREBUILT}" ]]; then
  echo "Missing kernel build tools at: ${KERNEL_BUILD_TOOLS_PREBUILT}" >&2
  exit 1
fi

# Export toolchain paths from the Android build tree.
export PATH="${CLANG_PREBUILT_DIR}/bin:${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}:${PATH}"

# Use build-tools sysroot and kernel-build-tools libraries for host tools.
export HOSTCFLAGS="--sysroot=${BUILDTOOLS_SYSROOT} -I${KERNEL_BUILD_TOOLS_PREBUILT}/include"
export HOSTLDFLAGS="--sysroot=${BUILDTOOLS_SYSROOT} -Wl,-rpath,${KERNEL_BUILD_TOOLS_PREBUILT}/lib64 -L ${KERNEL_BUILD_TOOLS_PREBUILT}/lib64 -fuse-ld=lld --rtlib=compiler-rt"

# Ensure dtc follows build.config.common's expected location.
export DTC="${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}/dtc"
export DTC_FLAGS="-@"

# Set Android kernel build environment values.
export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export LLVM=1
export DEPMOD=depmod
export ARCH=arm64
export TARGET_SOC=s5e8835

# Configure and build the kernel.
make s5e8835-a26xxx_defconfig
make
