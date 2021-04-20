# Qodot Next (Plugin)

## A next-generation successor to Qodot, written in GDNative Rust

Qodot Next is a full rewrite of the original GDNative release of Qodot, and acts as the Godot engine integration for the Quarchitect library.

It's presently in alpha testing stage; the core is there, but needs some polishing and testing before it can be considered done.

This repository holds the Godot plugin that interfaces with `qodot-next`.
The vast majority of its contents are `.gdns` files that hook into `qodot-next` and expose its functions to GDScript,
while the remainder is comprised of GDScript classes that were either impossible or impractical to encode using GDNative.

A compiled copy of the `qodot-next` needs to be present in `bin/` in order for `qodot-next-plugin` to run.

### New features

- Natively-parallelized parsing and geometry building processes
- Overhauled editor integration and resource system
- WAD3 support
- Support for taking .map files by godot resource or file path
- Support for searching textures by resource location, global file path or WAD
- Rebuild-on-change support for resource-based maps
