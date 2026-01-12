# Help - SM-A266B Open Source Kernel Repository

## Overview

This repository is dedicated to hosting and managing open source kernel files for the Samsung Galaxy A26 5G (SM-A266B) device. The repository uses automated GitHub Actions workflows to import, organize, and extract kernel source files from Google Drive.

## Repository Structure

After the import workflows run, the repository will contain:

```
.
├── .github/
│   └── workflows/          # GitHub Actions workflow files
├── kernel/
│   ├── opensource/         # Open source kernel components
│   └── platform/           # Platform-specific kernel files
├── twrp/                   # TWRP/Recovery related files
├── magisk/                 # Magisk module files
├── wildksu/                # WildKSU/KernelSU files
└── README.md
```

## Available Workflows

### 1. Import Drive Files (IDs)
**Files:** `.github/workflows/import-drive-links.yml` and `.github/workflows/import-drive-files.yml`

These workflows download kernel files from Google Drive using file IDs, sort them into appropriate directories, and extract archives.

**How to run:**
1. Go to the "Actions" tab in GitHub
2. Select "Import Drive files (IDs) -> sort -> extract -> commit"
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

**What it does:**
- Downloads files from predefined Google Drive file IDs
- Sorts files into directories based on filename patterns:
  - Files with "platform" → `kernel/platform/`
  - Files with "twrp" or "recovery" → `twrp/`
  - Files with "wildksu", "kernelsu", or "ksu" → `wildksu/`
  - Files with "magisk" → `magisk/`
  - All other files → `kernel/opensource/`
- Extracts ZIP, 7Z, and TAR archives
- Validates that no single file exceeds 95MB (GitHub file size limit)
- Commits and pushes changes to the repository

### 2. Import Drive Files (Links)
**File:** `.github/workflows/import-from-gdrive-links.yml`

Similar to the first workflow but uses full Google Drive URLs instead of just file IDs. This workflow includes additional features and more robust error handling.

**How to run:**
1. Go to the "Actions" tab in GitHub
2. Select "Import Drive files (links) -> sort -> extract -> commit"
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

**Additional features:**
- More detailed logging
- Better error handling with `set -euo pipefail`
- Creates an import map file (`IMPORT_MAP.txt`) showing where each file was sorted
- Uses full Google Drive URLs for better reliability

## Common Tasks

### Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Omargamal7/Sm-a266b-open-source-kernel-.git
   cd Sm-a266b-open-source-kernel-
   ```

2. **Import kernel files:**
   - Use one of the GitHub Actions workflows mentioned above
   - The workflows will automatically download, organize, and extract files

### Building the Kernel

The kernel can be built in two ways:

#### Option 1: Using GitHub Actions Workflows (Recommended)

The repository includes automated GitHub Actions workflows that build the kernel with KernelSU patches and repack it into init_boot.img:

1. **Go to the Actions tab** in the GitHub repository
2. **Select the appropriate workflow based on your branch:**
   - `Build Galaxy A26 Kernel (kernelsu)` - Builds from the `kernelsu` branch
   - `Build Samsung Galaxy A26 Kernel (KernelSU)` - Builds from the `Wildksu` branch  
   - `Build WildKSU Kernel (SM-A266B)` - Builds from the `wildksu` branch
   - `Build Galaxy A26 Kernel` - Manual trigger, general purpose build
3. **Click "Run workflow"** and select the appropriate branch
4. **Wait for the build to complete** (typically 20-30 minutes)
5. **Download artifacts:**
   - `kernel-image` or `kernelsu-a26-build` - compiled kernel Image and dtb files
   - `init_boot_patched` - patched init_boot.img with KernelSU kernel
   - `WildKSU-A26-AnyKernel` - flashable AnyKernel3 ZIP (wildksu workflow only)

The workflows automatically:
- Install all required build dependencies
- Download the correct toolchains (clang, gcc cross-compilers)
- Apply KernelSU/SUSFS patches (for KernelSU and WildKSU workflows)
- Build the kernel
- Unpack init_boot.img
- Replace the kernel in init_boot.img with the patched version
- Repack init_boot.img as `init_boot_patched.img`
- Package AnyKernel3 flashable ZIP (wildksu workflow only)

#### Option 2: Local Build in AOSP Environment

After importing the kernel source files, you can build locally inside an Android (AOSP) build tree:

1. **Start from the Android build tree root (AOSP):**
   ```bash
   cd /path/to/aosp
   ```

2. **Ensure the AOSP prebuilts are present:**
   - `prebuilts/clang/host/linux-x86/clang-r450784d/bin`
   - `build/kernel/build-tools/path/linux-x86` (provides `dtc`)
   - `prebuilts/kernel-build-tools/linux-x86`

   The kernel build expects `dtc` to resolve from:
   `build/kernel/build-tools/path/linux-x86/dtc`

3. **Run the build script from the kernel directory:**
   ```bash
   cd kernel/opensource
   ./build_kernel.sh
   ```

#### Option 3: Local Build with GitHub Actions Script

You can also use the GitHub Actions compatible build script locally:

1. **Install dependencies:**
   ```bash
   sudo apt install -y \
     bc bison flex build-essential libc6-dev libncurses-dev \
     libssl-dev libelf-dev dwarves rsync python3 \
     clang llvm lld device-tree-compiler \
     gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi
   ```

2. **Build the kernel:**
   ```bash
   cd kernel/opensource
   export GITHUB_WORKSPACE=/path/to/repo
   ./build_kernel_gha.sh
   ```

### Working with TWRP

Files in the `twrp/` directory contain recovery-related components:

1. Extract and examine the TWRP files
2. Follow TWRP building documentation for your specific use case

### Working with Magisk/KernelSU

Files in the `magisk/` and `wildksu/` directories contain root-related modules:

1. These files are intentionally not auto-extracted (preserved as-is)
2. Manual extraction and review recommended for security

## Limitations

- **File Size Limit:** Individual files cannot exceed 95MB due to GitHub's file size restrictions
- **Storage:** GitHub repositories have a soft limit of 1GB; large kernel sources may need Git LFS
- **Rate Limiting:** Google Drive may rate limit downloads if workflows run too frequently

## Troubleshooting

### Workflow Fails with "Large file found >95MB"

**Problem:** A file in the import exceeds GitHub's file size limit.

**Solution:**
1. Identify the large file
2. Split it into smaller chunks before uploading to Drive
3. Update the workflow to handle chunked files, or
4. Use Git LFS (Large File Storage) for files over 95MB

### Downloads Fail from Google Drive

**Problem:** `gdown` fails to download files.

**Solution:**
1. Verify the Google Drive file IDs/links are correct
2. Ensure files are set to "Anyone with the link can view"
3. Check if files are too large or require confirmation
4. Wait a few hours if rate-limited, then retry

### Extraction Fails

**Problem:** Archives don't extract properly.

**Solution:**
1. Check if the downloaded file is corrupted
2. Verify the archive format is supported (ZIP, 7Z, TAR, TGZ)
3. Manually download and test extraction locally
4. Review workflow logs for specific error messages

## Security Considerations

- **Code Review:** Always review kernel source code before building or using it
- **Magisk/Root Modules:** Exercise extreme caution with root-related files
- **Source Verification:** Verify the authenticity of kernel sources
- **Build Environment:** Use a clean, isolated build environment

## Contributing

If you want to contribute to this repository:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request with a clear description

## Additional Resources

- [Samsung Open Source Release Center](https://opensource.samsung.com/)
- [Android Kernel Documentation](https://source.android.com/devices/architecture/kernel)
- [TWRP Documentation](https://twrp.me/)
- [Magisk Documentation](https://topjohnwu.github.io/Magisk/)

## Support

For issues specific to the SM-A266B kernel or this repository:
- Open an issue on GitHub
- Provide detailed information about your problem
- Include relevant logs and error messages

## License

Kernel source code is typically licensed under GPL v2. Check individual files for specific licensing information.
