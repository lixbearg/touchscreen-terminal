# Windows release

## Artifact

`build/windows/Terminal.exe` is a single-file, x86-64 Windows executable with
the project PCK embedded. It does not need a separate `.pck`, runtime, or
resource folder next to it.

## Rebuilding

Requirements:

- Godot 4.7.2 (the exact version used for this build)
- Matching Windows export templates installed in the editor

From the project root:

```sh
mkdir -p build/windows
godot --headless --export-release "Windows Desktop" build/windows/Terminal.exe
```

The `Windows Desktop` preset in `export_presets.cfg` is already configured for:

- Release export template and GUI subsystem (no console window)
- Embedded PCK (`binary_format/embed_pck=true`), so the output is one `.exe`
- x86-64 architecture
- Windows icon and version metadata (`Terminal`, `1.0.0.0`)
- Exclusion of `addons/godOSC/demo/*`

## Deployment notes

- The project starts in fullscreen at 1080x1920
  (`display/window/size/mode=3`). The canvas stretches to the display.
- The mouse cursor is hidden while the game window has focus by the `Cursor`
  autoload in `scripts/cursor.gd`.
- The terminal listens for OSC over UDP on port **4646**. Allow inbound UDP
  4646 through Windows Firewall on the target machine, otherwise messages from
  the bridge will not arrive.
- The map buttons send OSC to `192.168.100.58:4646`. Change the `ip_address`
  and `port` on the `OSCClient` nodes in `scenes/button.tscn` if the bridge
  address differs on site.
- The executable is **unsigned**. For public distribution or to reduce
  SmartScreen warnings, sign `Terminal.exe` with an Authenticode/EV
  certificate after export.
- The project uses the Forward+ renderer and therefore needs a working Vulkan
  driver on the target machine. Validate on the exact terminal hardware.
  This single-file build does not bundle the optional D3D12/ANGLE sidecar
  DLLs; if a target machine cannot provide Vulkan, test that hardware before
  deployment rather than adding sidecar DLLs to the release.

## Customizing release metadata

Edit the `[preset.0.options]` section of `export_presets.cfg`:

- `application/file_version` and `application/product_version`
- `application/product_name`
- `application/file_description`
- `application/company_name`, `application/copyright`, `application/trademarks`

The icon is built from `icon.svg`. To regenerate the multi-resolution Windows
icon and the PNG boot splash:

```sh
magick RSVG:icon.svg -define icon:auto-resize=256,128,64,48,32,24,16 icon.ico
magick RSVG:icon.svg -resize 512x512 PNG32:icon_splash.png
```
