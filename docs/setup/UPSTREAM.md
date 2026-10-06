# Upstream provenance and project baseline

The user obtained Lyra Starter Game for Unreal Engine 5.8 through Epic Games
Launcher/Fab on 2026-10-06. The .uproject identifies the Samples category,
LyraGame/LyraEditor modules and EngineAssociation 5.8. The official engine used
for validation is Launcher UE 5.8.1. No engine source or installed-engine binaries
are copied into this repository.

The downloaded baseline contains about 2.52 GB of source, configuration, content
and supporting project files, excluding generated directories. Original Epic
copyright notices and Content/Legal third-party notices are preserved. No MIT,
Apache or other blanket license is assigned to Epic's sample by this setup.

References:
- [Official Lyra documentation](https://dev.epicgames.com/documentation/en-us/unreal-engine/lyra-sample-game-in-unreal-engine)
- [Official Lyra sample listing](https://www.fab.com/listings/93faede1-4434-47c0-85f1-bf27c0820ad0)
- [Unreal Engine EULA, including the Examples provisions](https://www.unrealengine.com/eula/unreal)

The listing identifies Lyra as UE-only content. Preserve its original terms and
notices when developing or distributing the Unreal-based project. Separately
acquired future Fab assets need their own provenance; do not assume this sample
baseline gives rights to unrelated marketplace material.

Setup changes are limited to the Arena runtime feature, editor-only test plugin,
Content/Python/arena_setup, enabling their dependencies in the .uproject and
disabling AndroidFileServer for this Windows development setup. A generated
Android connection token was removed from tracked config; original config and
project descriptors have ignored local backups. Commented EOS placeholders remain
placeholders; no account credentials were supplied or configured by setup.

Lyra core source, maps and existing gameplay assets are preserved. Bootstrap
templates remain in ArenaOfElements for the separate probe; gameplay work belongs
inside the real Lyra project. Large Unreal assets and the sample replay use LFS.
