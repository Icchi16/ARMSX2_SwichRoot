# ARMSX2 AppImage for Switchroot / Tegra X1

The official Linux ARM64 build currently compiles the application with
`-march=armv8.1-a`. Nintendo Switch uses Cortex-A57/Tegra X1, an ARMv8.0-A CPU,
so the official 4K AppImage can still terminate with `Illegal instruction`.
Page size and CPU instruction level are separate compatibility requirements.

## Build

1. Fork `ARMSX2/ARMSX2`.
2. Create `.github/workflows/switchroot-tegra-x1.yml`.
3. Copy the supplied workflow into that file.
4. Commit it to a branch named `switchroot-build`.
5. Open GitHub Actions and run **Build ARMSX2 for Switchroot Tegra X1**.
6. Download artifact `ARMSX2-switchroot-tegra-x1-arm64`.

The workflow patches the project at build time from ARMv8.1-A to ARMv8.0-A,
tunes for Cortex-A57, disables outlined/LSE atomics, uses 4K pages, disables LTO
for the first compatibility build, and packages against Ubuntu 22.04 userspace.

## Run

```bash
chmod +x ARMSX2-switchroot-tegra-x1-arm64.AppImage
APPIMAGE_EXTRACT_AND_RUN=1 QT_QPA_PLATFORM=xcb \
  ./ARMSX2-switchroot-tegra-x1-arm64.AppImage
```

Or use:

```bash
./run-on-switchroot.sh ./ARMSX2-switchroot-tegra-x1-arm64.AppImage
```

## Confirm the official failure

```bash
APPIMAGE_EXTRACT_AND_RUN=1 ./official-4k.AppImage
echo "exit=$?"
```

Exit code `132` or the message `Illegal instruction` strongly confirms the ISA
mismatch. A `GLIBC_x.y not found` message is a separate userspace compatibility
problem.
