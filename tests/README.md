# cloche-standard tests

Mirror of [cloche-pro-workstation/tests/run.sh](../../cloche-pro-workstation/tests/README.md):
same 7 feature categories from the workspace-root `CLAUDE.md` gap list, but since cloche-standard
is the *reference* implementation, every check here asserts the feature **is present**. Keeping
both suites in sync turns the gap list into a two-sided regression guard — this suite catches
cloche-standard ever losing one of these features, not just tracks pro-workstation gaining them.

Uses the shared harness — see [cloche-utils/testing/README.md](../../cloche-utils/testing/README.md)
for `test-lib.sh` details, local/CI usage, and the `CLOCHE_UTILS_DIR` env var.

Run: `./tests/run.sh [image-tag]` (`BUILD_METHOD=bluebuild`, builds `$RECIPE`).

## Checks

| Feature | Checks |
|---|---|
| 1. KDE skel files | `kactivitymanagerdrc`, `kglobalshortcutsrc`, `konsolerc`, `kscreenlockerrc` under `/etc/skel/.config/`; Konsole `Main.profile` under `/etc/skel/.local/share/konsole/` |
| 2. Dynamic KDE wallpaper | `images/` + `images-dark/` dirs under `/usr/share/wallpapers/*/contents/`; `DynamicMode=2` in wallpaper metadata |
| 3. GNOME CustomTransparent theme | `/usr/share/themes/CustomTransparent` dir + `gnome-shell.css` inside it |
| 4. rpm-repo packages | `cloche-common`, `cloche-kde-defaults`, `cloche-gnome-defaults`, `cloche-wallpapers-1` installed |
| 5. Display manager | `plasmalogin` system user exists; `plasmalogin.service` enabled in systemd presets |
| 6. Boot-speed masks | `NetworkManager-wait-online.service` masked (symlinked to `/dev/null`) |
| 7. plasma-discover exclusion | `plasma-discover` and `plasma-discover-notifier` both **not** installed |

## ⚠️ Unverified — confirm before trusting in CI

These paths were carried over from the pro-workstation gap analysis, not confirmed against this
repo's actual `files/` tree or recipe YAML:

- Which `files/<variant>/` subdir actually holds the KDE skel files (`system`, `kde`, `common`?).
- The real wallpaper package/dir name and its exact path under `files/` or `recipes/`.
- The recipe step (script module or dnf module) that installs the `rpm-repo` packages.
- Whether `sddm.service` or `plasmalogin.service` is the one actually enabled here.
- The real list of masked systemd units in the `systemd` module.
