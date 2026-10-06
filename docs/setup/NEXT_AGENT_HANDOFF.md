# Next agent handoff

```text
REPOSITORY_ROOT=C:\Users\marti\Documents\ChatGPT\Arena of Elemts
REMOTE=https://github.com/zoate103/arena-of-elements.git
BRANCH=codex/setup-agent-environment
ENGINE_ROOT=C:\Program Files\Epic Games\UE_5.8
ENGINE_VERSION=5.8.1
PROJECT_EXPECTED=GameDirectory\LyraStarterGame\LyraStarterGame.uproject
PROJECT_STATUS=AWAITING_OFFICIAL_LYRA_DOWNLOAD
VALIDATION_HOST=Tools\ValidationHost\ArenaSetupProbe.uproject
STAGED_LAYER=ArenaOfElements
EVIDENCE=artifacts\setup
```

The user's current template under GameDirectory/Arena_of_Elements is explicitly
not selected as the foundation. Preserve it. Do not confuse validation-host
passes with Lyra acceptance. Read the latest SETUP_REPORT and user messages first.

Once Lyra's download completes:

1. Inspect .uproject association and Source/LyraGame; ensure no download or target
   editor is still writing files. Find-Unreal must select its associated engine.
2. Run `./Tools/Unreal/Initialize-Lyra.ps1` from PowerShell 7. It preserves source
   and backs up the project descriptor, adding only the reviewed setup layer.
3. Run `./Tools/Unreal/Build-Editor.ps1 -GenerateProjectFiles`.
4. Run `./Tools/Unreal/Run-Python.ps1 -Script validate_editor.py -FullEditor`,
   then validate_content.py and automation_smoke_test.py with the same command.
5. Run `./Tools/Unreal/Run-Tests.ps1` and inspect the fresh JSON report and logs.
6. Run `./Tools/Unreal/Launch-Editor.ps1` for interactive validation;
   `./Tools/Unreal/Collect-Logs.ps1` collects recent editor/build logs.
7. Follow MULTIPLAYER.md for local PIE checks and rendering evidence. No multiplayer
   success, feature activation or visual correctness has been established yet.
8. Review licensed content, LFS sizes and Git changes before committing the
   downloaded project. Keep changes on a setup branch; never directly push main.
9. Update ENVIRONMENT, SETUP_REPORT and this handoff with actual results. Remove
   the obsolete manual-action document only after its gate is resolved.

Runtime architecture: `<Lyra>/Plugins/GameFeatures/ArenaOfElements`.
Editor test plugin: `<Lyra>/Plugins/Editor/ArenaSetupAutomation`.
Python: `<Lyra>/Content/Python/arena_setup`. The runtime feature starts Installed;
GameFeatureData and Lyra experience integration are future work. Preserve Lyra
core and module names. Do not implement combat until a separate gameplay prompt.

The independent probe passed Editor compilation, full editor startup, all three
Python validators, asset create/save/load/delete and the Arena module automation
test. See SETUP_REPORT for exact evidence paths and repaired initial failures.
Automation pins process culture to English because stock engine self-tests compare
localized formatting against literal English strings.

Current limitations: Lyra is unavailable; full acceptance remains blocked despite
the independent probe passing. PowerShell 7 is required. Headless NullRHI tests do
not exercise viewport/PIE/rendering. No additional software or MCP was installed.
Unreal warnings must be classified by actual impact rather than silently ignored.
