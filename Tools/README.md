# Arena of Elements tooling

Use **PowerShell 7** from the repository root. Every command resolves its paths
from the script location, so paths containing spaces are supported. Git LFS must
be installed before obtaining Unreal assets. No remote-control service is needed.

## Lyra setup and daily commands

The real project is `GameDirectory/LyraStarterGame/LyraStarterGame/LyraStarterGame.uproject`.
For a fresh Git clone, run `git lfs pull` before building. Use the installed UE 5.8
engine and matching compiler/SDK documented in docs/setup/ENVIRONMENT.md.

```powershell
.\Tools\Unreal\Find-Unreal.ps1
.\Tools\Unreal\Build-Editor.ps1 -GenerateProjectFiles
.\Tools\Unreal\Run-Python.ps1 -Script validate_editor.py -FullEditor
.\Tools\Unreal\Run-Python.ps1 -Script validate_content.py
.\Tools\Unreal\Run-Python.ps1 -Script automation_smoke_test.py
.\Tools\Unreal\Run-Tests.ps1
.\Tools\Unreal\Launch-Editor.ps1
.\Tools\Unreal\Collect-Logs.ps1
```

Discovery chooses exactly one project declaring the LyraGame module under
GameDirectory. It intentionally rejects the unrelated Arena_of_Elements template
as the default. All commands except Test-Tooling accept `-Project <path.uproject>`;
engine commands accept `-EngineRoot <directory>`. `UE_ROOT` is an optional override.
Numeric engine associations must match; the scripts do not silently upgrade or
downgrade a project. Registry and Epic Launcher manifests support custom locations.

Initialize-Lyra is only for a fresh official Lyra download: it copies the initial
ArenaOfElements bootstrap layer and refuses differing
destination files, and backs up the .uproject before enabling plugins. Re-running
with identical files is safe. Once integrated, edit the files inside Lyra and
retire/reconcile the staging layer rather than blindly copying over new work.
GameplayTags and GameplayTasks are **C++ modules**, not standalone plugins.
Python, EditorScriptingUtilities and ArenaSetupAutomation are editor-only.

Build-Editor finds the Editor.Target.cs automatically; use `-Target LyraEditor`
if a project has multiple editor targets. Close the target project's Editor
before compiling. It uses the engine's bundled .NET and UnrealBuildTool directly.
For a newly imported project whose source is still entirely untracked, use
`-InitialBuild`. This applies UBT's `-DisableAdaptiveUnity` for that invocation:
normal unity compilation remains enabled, avoiding a separate compile for every
file classified as new by Git. Compiler warnings/errors are unchanged. Omit it
for ordinary incremental work once the project is tracked.

## Optional isolated validation host

This host helps isolate engine/toolchain failures from Lyra. Normal work uses the
real Lyra project above; probe success cannot replace Lyra acceptance gates.

```powershell
$probe = '.\Tools\ValidationHost\ArenaSetupProbe.uproject'
$python = '.\ArenaOfElements\Content\Python\arena_setup'
.\Tools\Unreal\Test-Tooling.ps1
.\Tools\Unreal\Find-Unreal.ps1 -Project $probe
.\Tools\Unreal\Build-Editor.ps1 -Project $probe
.\Tools\Unreal\Run-Python.ps1 -Project $probe -Script "$python\validate_editor.py" -FullEditor
.\Tools\Unreal\Run-Python.ps1 -Project $probe -Script "$python\validate_content.py"
.\Tools\Unreal\Run-Python.ps1 -Project $probe -Script "$python\automation_smoke_test.py"
.\Tools\Unreal\Run-Tests.ps1 -Project $probe
.\Tools\Unreal\Collect-Logs.ps1 -Project $probe
```

## Evidence and failure handling

Every invocation creates a unique `artifacts/setup/<operation>-<timestamp>-<id>`.
Inspect command.json (exact executable/arguments/exit/timeout), stdout.log,
stderr.log and Unreal.log/UnrealBuildTool.log. Tests export report/index.json.
Collect-Logs copies recent Saved/UBT logs and the latest build/Python/test/editor
invocation logs into a new collection with a source manifest.
Logs are local and ignored; review them before sharing because engine logs can
contain machine/account/network details. Summaries live in docs/setup.

An unsuccessful process, timeout, logged Unreal error/failed ensure, missing completion marker,
missing test report, zero tests or incomplete/failed tests produces a nonzero
PowerShell exit when invoked using `pwsh -File`. Do not add unconditional `exit 0`
in callers. Diagnose the first actionable error before retrying.

Build timeout defaults to 3600 seconds, Python/tests to 1200; override with
`-TimeoutSeconds`. Timeout terminates only the process tree this invocation owns.
Python defaults to commandlet mode; `-FullEditor` validates full startup and the
default map. Headless validation uses NullRHI; add `-Render` for rendering tests.
Neither headless tests nor a process launching prove visual quality or PIE.
Automation processes set `-culture=en` for deterministic engine self-test string
comparisons. This does not change the user's normal editor/system language.

The asset smoke test creates a UUID-named CurveFloat asset under
`/Game/Developers/ArenaSetupSmoke`, saves and reloads it, then removes that asset
only. It never deletes the folder or other assets. Read-only validators do not
save production assets. No general cleanup/delete script is provided.
