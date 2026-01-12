# SM-A266B Open Source Kernel

Open source kernel repository for Samsung Galaxy A26 5G (SM-A266B).

This repository provides automated workflows for importing, organizing, and managing kernel source files from Google Drive.

## Quick Start

1. Navigate to the **Actions** tab
2. Choose a workflow:
   - **Import workflows** - Download and organize kernel files from Google Drive
     - "Import Drive files (IDs) -> sort -> extract -> commit"
     - "Import Drive files (links) -> sort -> extract -> commit"
   - **Build workflows** - Compile the kernel with KernelSU and create init_boot.img
     - "Build Galaxy A26 Kernel (kernelsu)" - for the kernelsu branch
     - "Build Samsung Galaxy A26 Kernel (KernelSU)" - for the Wildksu branch
     - "Build WildKSU Kernel (SM-A266B)" - for the wildksu branch
3. Run the workflow and download the artifacts

## Build Features

The automated build workflows provide:
- ✅ Complete kernel compilation with KernelSU/SUSFS patches
- ✅ Automatic toolchain setup (no AOSP environment required)
- ✅ init_boot.img repacking with patched kernel
- ✅ AnyKernel3 flashable ZIP creation
- ✅ Ready-to-flash kernel images

## Documentation

📖 **[Read the full documentation in HELP.md](HELP.md)** for:
- Detailed workflow usage instructions
- Repository structure explanation
- Building the kernel
- Troubleshooting common issues
- Security considerations

🧹 **[Branch Management](HOW_TO_CLEANUP.md)** - Clean up messy branches and keep your repository organized

📚 **[Best Practices Guide](BRANCH_CLEANUP_GUIDE.md)** - Learn how to avoid accidental branches and manage Git effectively

## Repository Structure

- `kernel/opensource/` - Open source kernel components
- `kernel/platform/` - Platform-specific kernel files
- `twrp/` - TWRP/Recovery files
- `magisk/` - Magisk modules
- `wildksu/` - WildKSU/KernelSU files

## Contributing

Contributions are welcome! Please read [HELP.md](HELP.md) for more information.

## Custom automation

This repository does not include a general-purpose “custom agent” that can fix issues automatically. If you need new automation, please open an issue with specific requirements so it can be designed appropriately.

## License

Kernel source code is licensed under GPL v2. See individual files for specific licensing.
