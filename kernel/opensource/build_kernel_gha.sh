#!/bin/bash
# GitHub Actions compatible build script for Samsung A26 kernel
set -euo pipefail

KERNEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${KERNEL_DIR}"

# Check if we're in a GitHub Actions environment
if [[ -n "${GITHUB_WORKSPACE:-}" ]]; then
  echo "Running in GitHub Actions environment"
  USE_PREBUILTS=false
else
  echo "Running in local/AOSP environment"
  USE_PREBUILTS=true
fi

if [[ "${USE_PREBUILTS}" == "false" ]]; then
  # GitHub Actions environment - use system tools and downloaded toolchain
  echo "Setting up build environment for GitHub Actions..."
  
  # Find clang in PATH (should be installed via apt)
  if ! command -v clang &> /dev/null; then
    echo "Error: clang not found. Please install clang." >&2
    exit 1
  fi
  
  # Check for required tools
  for tool in make gcc dtc; do
    if ! command -v "$tool" &> /dev/null; then
      echo "Error: $tool not found. Please install it." >&2
      exit 1
    fi
  done
  
  # Use system clang/gcc
  export CC=clang
  export HOSTCC=gcc
  export CROSS_COMPILE=aarch64-linux-gnu-
  export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
  
  # Set architecture and LLVM
  export ARCH=arm64
  export LLVM=1
  export LLVM_IAS=1
  
  # Android-specific environment variables
  export PLATFORM_VERSION=13
  export ANDROID_MAJOR_VERSION=t
  export TARGET_SOC=s5e8835
  export DEPMOD=depmod
  export DTC_FLAGS="-@"
  
  echo "Build environment configured for GitHub Actions"
else
  # AOSP environment - use the original script logic
  ROOT_DIR="$(cd "${KERNEL_DIR}/../.." && pwd)"
  
  # Define expected prebuilt locations in an Android build tree
  CLANG_VERSION="clang-r450784d"
  CLANG_PREBUILT_DIR="${ROOT_DIR}/prebuilts/clang/host/linux-x86/${CLANG_VERSION}"
  BUILDTOOLS_PREBUILT_BIN="build/kernel/build-tools/path/linux-x86"
  BUILDTOOLS_SYSROOT="${ROOT_DIR}/build/kernel/build-tools/sysroot"
  KERNEL_BUILD_TOOLS_PREBUILT="${ROOT_DIR}/prebuilts/kernel-build-tools/linux-x86"
  
  # Verify required prebuilts exist
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
  
  # Export toolchain paths
  export PATH="${CLANG_PREBUILT_DIR}/bin:${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}:${PATH}"
  
  # Use build-tools sysroot and libraries
  if [[ -f "${BUILDTOOLS_SYSROOT}/usr/include/sys/types.h" ]]; then
    export HOSTCFLAGS="--sysroot=${BUILDTOOLS_SYSROOT} -I${KERNEL_BUILD_TOOLS_PREBUILT}/include"
    export HOSTLDFLAGS="--sysroot=${BUILDTOOLS_SYSROOT} -Wl,-rpath,${KERNEL_BUILD_TOOLS_PREBUILT}/lib64 -L ${KERNEL_BUILD_TOOLS_PREBUILT}/lib64 -fuse-ld=lld --rtlib=compiler-rt"
  else
    export HOSTCFLAGS="-I${KERNEL_BUILD_TOOLS_PREBUILT}/include"
    export HOSTLDFLAGS="-Wl,-rpath,${KERNEL_BUILD_TOOLS_PREBUILT}/lib64 -L ${KERNEL_BUILD_TOOLS_PREBUILT}/lib64 -fuse-ld=lld --rtlib=compiler-rt"
  fi
  export HOSTCC=gcc
  
  export DTC="${ROOT_DIR}/${BUILDTOOLS_PREBUILT_BIN}/dtc"
  export DTC_FLAGS="-@"
  
  # Android kernel build environment
  export PLATFORM_VERSION=13
  export ANDROID_MAJOR_VERSION=t
  export LLVM=1
  export DEPMOD=depmod
  export ARCH=arm64
  export TARGET_SOC=s5e8835
  
  echo "Build environment configured for AOSP"
fi

# Configure and build the kernel
echo "Configuring kernel with s5e8835-a26xxx_defconfig..."
if ! make s5e8835-a26xxx_defconfig; then
  echo "Error: Failed to configure kernel with defconfig" >&2
  exit 1
fi

echo "Building kernel..."
if ! make -j$(nproc); then
  echo "Error: Kernel build failed" >&2
  echo "Please check the build logs above for specific errors" >&2
  exit 1
fi

echo "Kernel build completed successfully!"
