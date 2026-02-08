<div align="center">
  <img src="assets/logo.png" width="160" alt="Kaku Logo" />
  <h1>Kaku</h1>
  <p><em>A fast, out-of-the-box terminal built for AI coding.</em></p>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey.svg?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/built%20with-Rust-orange.svg?style=flat-square" alt="Rust">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="License">
</p>

<p align="center">
  <img src="assets/kaku.png" alt="Kaku Screenshot" width="1000" />
  <br/>
  Kaku is a deeply customized fork of <a href="https://github.com/wez/wezterm">WezTerm</a>, designed for an <b>out-of-the-box</b> experience.
</p>

## Features

- **Out-of-the-Box Aesthetics**: Beautiful defaults, polished UI/UX, and carefully selected fonts—no configuration needed to look good.
- **Built for AI Coding**: Optimized for the "Vibe Coding" era, designed to enhance AI-assisted workflows.
- **Streamlined & Fast**: Stripped of heavy, unused features from WezTerm. Simplified logic for a cleaner, lighter, and more performant experience.
- **MacOS Native**: Deeply optimized for macOS, providing a native feel that fits perfectly into your workflow.
- **GPU Accelerated**: Blazing fast rendering powered by modern GPU APIs.
- **Lua Configuration**: Retains WezTerm's powerful Lua scripting for infinite customization when you need it.

## Quick Start

> **Note**: Kaku is currently in **active development** and is primarily built for my personal workflow. It simplifies WezTerm's logic for better performance and cleaner architecture.

### Build from Source

Kaku is currently built from source. Ensure you have Rust and Cargo installed.

```bash
# 1. Clone the repository
git clone https://github.com/tw93/Kaku.git
cd Kaku

# 2. Build the application
./scripts/build.sh

# 3. Run the app
open dist/Kaku.app
```

> **Note**: The build script is optimized for macOS and will verify your environment before building.

## Configuration

Kaku uses a prioritized configuration system to ensure stability while allowing customization.

**Config Load Order:**

1. **Environment Variable**: `KAKU_CONFIG_FILE` (if set)
2. **Bundled Config**: `Kaku.app/Contents/Resources/kaku.lua` (Default experience)
3. **User Config**: `~/.kaku.lua` or `~/.config/kaku/kaku.lua`

To customize Kaku, simply create a `~/.kaku.lua` file. It will override the bundled defaults where specified.

## Development

For developers contributing to Kaku:

```bash
# Build and verify
cargo check
cargo test

# Build and open immediately
./scripts/build.sh --open

# Clean build artifacts
rm -rf dist Kaku.app
```

## License

MIT License. See [LICENSE](LICENSE.md) for details.
