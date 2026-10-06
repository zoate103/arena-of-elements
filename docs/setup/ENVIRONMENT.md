# Environment — discovered 2026-10-06 (Europe/Vienna)

| Item | Detected value |
| --- | --- |
| OS | Windows 11 Pro x64, 10.0.26200 |
| Workspace/repository | `C:\Users\marti\Documents\ChatGPT\Arena of Elemts` |
| Git remote | `https://github.com/zoate103/arena-of-elements.git` |
| Setup branch | `codex/setup-agent-environment` |
| Selected future project | `GameDirectory\LyraStarterGame\LyraStarterGame.uproject` (not yet downloaded) |
| Preserved user template | `GameDirectory\Arena_of_Elements\Arena_of_Elements.uproject`, UE 5.8, not Lyra |
| Validation host | `Tools\ValidationHost\ArenaSetupProbe.uproject` |
| Preferred engine | UE 5.8.1, changelist 56057345 |
| Engine root | `C:\Program Files\Epic Games\UE_5.8` |
| Other engine locations | UE_5.6 folder; Launcher records UE 5.7.3. Neither selected. |
| Visual Studio | Build Tools 2022 17.14.8, native x64/x86 compiler component installed |
| Compiler | MSVC **14.44.35211**, cl.exe 19.44.35211.0 |
| Compiler directory | `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207` |
| Windows SDK | 10.0.26100.0 with headers, resource compiler and libraries recognized by UBT |
| .NET | System SDK 9.0.313; UBT uses engine-bundled .NET 10.0 win-x64 |
| CMake / Ninja | VS-bundled CMake 3.31.6-msvc6 and Ninja 1.12.1; not on default PATH |
| PowerShell | 7.6.5 available via Codex runtime |
| Git | 2.47.1.windows.2; existing name/email retained |
| Git LFS | 3.6.1; installed locally for this repository |
| Long paths | Git core.longpaths=true at repository scope; system policy unchanged |
| Storage at discovery | C: approximately 104 GiB free, E: 494 GiB, F: 247 GiB |
| RAM | approximately 32 GiB physical; low free memory during initial build |

Compiler folder naming is not its patch version: the actual executable is
14.44.35211, above the 14.44.35210 ban in the installed engine's Windows_SDK.json.
No toolchain replacement, software installation, global execution-policy change,
antivirus exception or system-wide identity change was necessary.

No relevant UE_ROOT/Unreal/toolchain environment override was found. Scripts
discover engines through project association, registry, LauncherInstalled.dat and
common locations. An explicit EngineRoot/UE_ROOT may override location, not numeric
version compatibility. No credentials are needed in stored commands.

Lyra was not found in targeted searches of Documents/Unreal Projects, nearby
Documents projects, E:/Dev, E:/Dev/UE, UE Game Assets, Epic installation manifests
and Epic VaultCache/FabLibrary. ArenaGame (5.8) and ElementalConflux (5.7) are
separate non-Lyra projects; neither was changed. The user explicitly requested
Lyra after the new Arena_of_Elements template was discovered.

The user-selected GameDirectory location takes precedence over the proposed
C:/Dev convention. All scripts quote/support this path with spaces. If future
asset nesting hits Windows limits, use a shorter clone; do not move/delete the
user's project silently.

Editor: `<engine>\Engine\Binaries\Win64\UnrealEditor.exe`.
Commandlet: `<engine>\Engine\Binaries\Win64\UnrealEditor-Cmd.exe`.
UBT: `<engine>\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll`.
Canonical commands and report locations: [Tools/README.md](../../Tools/README.md).
