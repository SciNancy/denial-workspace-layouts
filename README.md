# Denial Workspace Layouts

Per-workspace layout overrides + dashboard management UI for [Denial](https://github.com/denialwm/denial) Wayland compositor.

> **Upstream**: This is a patch against [denialwm/denial](https://github.com/denialwm/denial). All Denial source code remains © Doctor Logix and contributors, licensed under GPL-3.0-only. This patch adds per-workspace layout management on top of upstream Denial.

## What it does

- **Dashboard card** (win+I): manage workspace count (1-9) and per-workspace layout (stacking/dwindle/scrolling)
- **Per-workspace layout overrides**: each workspace can have its own layout, independent of the global default
- **`denialctl layout` CLI**: query/set/unset per-workspace layouts from terminal
- **System bar meters**: memory and network readouts on the desktop system bar,
  with a fixed-width network column so the bar no longer shifts when a rate
  changes width

## Requirements

- Denial `v0.4.4` (commit `0fccf2c`) — `workspace-layouts.patch` is generated
  against this release and applies to a clean checkout of it. For an older
  release, check out that tag and use an earlier revision of the patch:
  `git log --oneline -- workspace-layouts.patch`.
- `denial-ui-development` package (provides `denial-ui` tool and patched Flutter SDK)
- Rust toolchain (only if you want `denialctl layout` CLI; the dashboard card works without it)

## Install

### Quick (dashboard card only, no Rust compile)

```bash
git clone --branch v0.4.4 --depth 1 https://github.com/denialwm/denial.git
cd denial
curl -L https://github.com/SciNancy/denial-workspace-layouts/raw/main/workspace-layouts.patch | git apply -
denial-ui prepare-profile
denialctl ui profile
```

Then press win+I to see the workspaces card.

### Full (with `denialctl layout` CLI)

```bash
git clone --branch v0.4.4 --depth 1 https://github.com/denialwm/denial.git
cd denial
curl -L https://github.com/SciNancy/denial-workspace-layouts/raw/main/workspace-layouts.patch | git apply -

# Build Rust binaries (denialctl with layout commands)
cargo build --release
sudo cp target/release/denialctl /usr/bin/denialctl
sudo cp target/release/deniald /usr/bin/deniald

# Build and activate Dart UI
denial-ui prepare-profile
denialctl ui profile
```

### Persistent (survives reboot)

Add to your shell rc file (`~/.bashrc` or `~/.zshrc`):

```bash
denial-branch() {
  DENIAL_FLUTTER_BUNDLE="$HOME/.cache/denial/ui-development/profile/bundle" \
    exec /usr/bin/denial-session "$@"
}
```

Then launch with `denial-branch` instead of `denial-session`.

## Update after Denial upgrade

```bash
cd denial
git fetch origin main
git rebase origin/main
# resolve conflicts if any
denial-ui prepare-profile
denialctl ui profile
```

## Uninstall

```bash
denialctl ui restore
```

To also remove the Rust changes, reinstall the official denial package.

## License

The patch content is licensed under GPL-3.0-or-later, matching upstream Denial.

See [LICENSE](LICENSE) for the full GPL-3.0 license text.
See [NOTICE](NOTICE) for upstream attribution.
