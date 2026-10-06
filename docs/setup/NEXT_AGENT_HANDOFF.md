# Next agent handoff

```text
REPOSITORY_ROOT=C:\Users\marti\Documents\ChatGPT\Arena of Elemts
REMOTE=https://github.com/zoate103/arena-of-elements.git
BRANCH=codex/setup-agent-environment
ENGINE_ROOT=C:\Program Files\Epic Games\UE_5.8
ENGINE_VERSION=5.8.1
PROJECT=GameDirectory\LyraStarterGame\LyraStarterGame\LyraStarterGame.uproject
PROJECT_STATUS=OFFICIAL_LYRA_INTEGRATED
VALIDATION_HOST=Tools\ValidationHost\ArenaSetupProbe.uproject
BOOTSTRAP_LAYER=ArenaOfElements
EVIDENCE=artifacts\setup
```

Read SETUP_REPORT.md and AGENTS.md before changing anything. The selected project
is the real Lyra download, including the second LyraStarterGame directory created
by the Launcher. Preserve that path and the LyraGame/LyraEditor module names.
The user's separate template in GameDirectory/Arena_of_Elements remains untracked;
do not delete it or include it in the Lyra baseline.

## Canonical commands

Use PowerShell 7 from the repository root. On a fresh clone, first install the
documented official engine/toolchain and run `git lfs pull`. The scripts discover
the actual project and associated engine; no manual path substitution is needed.

```powershell
.\Tools\Unreal\Find-Unreal.ps1
.\Tools\Unreal\Build-Editor.ps1 -GenerateProjectFiles
.\Tools\Unreal\Run-Python.ps1 -Script validate_editor.py -FullEditor
.\Tools\Unreal\Run-Python.ps1 -Script validate_content.py
.\Tools\Unreal\Run-Python.ps1 -Script automation_smoke_test.py
.\Tools\Unreal\Run-Tests.ps1
.\Tools\Unreal\Collect-Logs.ps1
.\Tools\Unreal\Launch-Editor.ps1
```

Close the target project's Editor before building. The build invokes the installed
engine's bundled dotnet.exe and UnrealBuildTool.dll for LyraEditor Win64 Development.
Run-Python and Run-Tests invoke UnrealEditor-Cmd.exe against that same project.
Launch-Editor opens UnrealEditor.exe interactively; launching alone is not a pass.
Each automated invocation records arguments, native exit status and fresh logs.
Tests must actually execute and export report/index.json; zero tests are rejected.
See Tools/README.md for overrides, timeout handling and the isolated probe commands.

Initialize-Lyra already completed and passed an idempotence check. Do not rerun it
after editing the integrated layer: it is a fresh-download bootstrap helper that
refuses differing destination files. The optional -InitialBuild switch was useful
for the entirely untracked initial import; normal subsequent builds should omit it.

## Canonical implementation locations

All paths below are relative to GameDirectory/LyraStarterGame/LyraStarterGame:

- Plugins/GameFeatures/ArenaOfElements: compiled runtime module; future gameplay.
- Plugins/Editor/ArenaSetupAutomation: ArenaOfElements.Setup.ModuleLoads C++ test.
- Content/Python/arena_setup: editor/content validation and temporary asset test.
- Config: original Lyra settings; consult MULTIPLAYER.md before local PIE testing.

The root ArenaOfElements directory is the bootstrap/probe copy only. Edit the
integrated Lyra files for game development. Preserve Lyra core wherever possible.
The Arena feature starts Installed; its module-load test does not activate a
GameFeatureData asset. Create and register that asset and integrate a Lyra experience
as part of the separate gameplay implementation, using supported editor APIs.

## Validation boundaries and known limitations

Actual Lyra build/startup/Python/test evidence is recorded in SETUP_REPORT.md.
The initial isolated probe remains useful for diagnosis but is not the selected
project. Headless runs use NullRHI and do not prove viewport quality, PIE,
replication, bots or 3v3 gameplay. MULTIPLAYER.md prepares those future scenarios.
Use -Render for rendering-capable automation and collect visual evidence when
validating future gameplay; no visual or multiplayer pass has been claimed.

Automation pins process culture to English because built-in engine tests compare
formatted text against literal English expectations. Normal editor/system language
is unchanged. Low available RAM can limit build parallelism; the successful build
recovered automatically from UBA memory-pressure retries. Optional VS IDE integration
is missing, but the installed native command-line compiler/SDK works.

The downloaded sample already enables experimental Epic assistant/toolset plugins;
see EDITOR_CONTROL_OPTIONS.md for the limited audit. No community MCP, account
credentials, external MCP connection or production backend was installed/configured.
AndroidFileServer is disabled for this Windows setup, and its generated connection
token is excluded from versioned config. Original descriptor/config backups stay local.
Preserve Epic notices and licensing (UPSTREAM.md). Do not reformat stock Lyra files
merely to clear upstream whitespace warnings. Generated output and raw logs are ignored.

No combat, elemental interactions or other Arena gameplay has been implemented.
Begin gameplay only upon the separate implementation request.
