# Setup Summary

2026-10-06, Europe/Vienna. Environment/tooling preparation only; no gameplay.
The user explicitly chose official Lyra as the foundation. Lyra is absent.
The separate user-created C++ template is preserved without modification.

# Installed / Detected

Windows 11 Pro x64; UE 5.8.1; VS Build Tools 2022 17.14.8; actual MSVC
14.44.35211; Windows SDK 10.0.26100.0; Git 2.47.1; Git LFS 3.6.1;
PowerShell 7.6.5. See ENVIRONMENT.md. No third-party software was installed.

# Changes Made

Created codex/setup-agent-environment and configured the supplied GitHub origin,
repository-local long paths and LFS hooks. Added Unreal ignores/LFS patterns,
agent instructions, build/discovery/Python/test/launch/log tooling, a collision-safe
Lyra integration command, minimal runtime feature and editor test plugins,
three Python validators, an isolated validation host and setup/handoff docs.
No user-created assets or unrelated projects were modified.

# Unreal Validation

| Acceptance gate | Actual Lyra project | Independent preparation evidence |
| --- | --- | --- |
| A — toolchain | PASS | UBT compiled the initial probe using detected MSVC/SDK |
| B — project | BLOCKED | Repository valid; official Lyra project missing |
| C — build | BLOCKED | Probe Editor + both plugins compile, exit 0 |
| D — Unreal start | BLOCKED | Full editor startup and subsystem checks PASS in probe |
| E — Python | BLOCKED | Editor/content validation and asset create/save/load/delete PASS in probe |
| F — automation | BLOCKED | ArenaOfElements.Setup.ModuleLoads: 1 success, 0 failures in probe |
| G — agent tooling | PASS for probe; Lyra pending | Discovery/build/Python/test/log commands executed; interactive launch prepared |
| H — documentation | PASS | Required documents and agent instructions present |

# Build Result

Initial validation-host Editor target compiled successfully, exit 0, using UE
5.8.1/MSVC 14.44.35211/Windows SDK 10.0.26100.0. Evidence:
`artifacts/setup/build-20261006-025732-a914463c`.
Project file generation passed with exit 0 under
`artifacts/setup/build-20261006-030203-04c6ea56/generation`.
Final build including the runtime feature and editor automation plugin passed,
exit 0, in 136.68 seconds: `artifacts/setup/build-20261006-030203-04c6ea56`.
After the final probe-only plugin/config cleanup, Build-Editor passed again,
exit 0, in 11.69 seconds: `artifacts/setup/build-20261006-031213-d71e3b55`.
There has been no Lyra build; never interpret the probe as passing gate C for Lyra.

# Python Automation Result

All three Python files passed AST parsing and actual execution inside Unreal.

| Run | Result | Evidence under artifacts/setup |
| --- | --- | --- |
| Full editor + validate_editor.py | PASS, exit 0, expected project/APIs/subsystems/asset registry | python-20261006-031115-6c2ceff8 |
| validate_content.py commandlet | PASS, exit 0; empty probe content registry queried | python-20261006-030705-717bfb96 |
| automation_smoke_test.py commandlet | PASS, exit 0; unique CurveFloat saved, loaded and removed | python-20261006-030811-c9b0e450 |

Final logs were rechecked for any logged Error, fatal exception or failed ensure;
none found. The temporary smoke asset was removed; no .uasset remains in probe
Content. This is functional editor automation evidence, not gameplay/rendering.

Repairs were driven by actual failures:

1. Missing GameFeatureData asset-manager rule caused commandlet exit 1. Added the
   rule to the probe's DefaultGame.ini; content validation then passed. Real Lyra
   has its own asset-manager configuration and must be validated separately.
2. PrimaryDataAsset is abstract in this engine; attempting to instantiate it caused
   an ensure/exit -1. Replaced the temporary fixture with a concrete CurveFloat;
   create/save/load/delete then passed without errors. Failed-run evidence remains
   at python-20261006-030716-c680bc32; no production assets were involved.
3. German process culture made built-in UnifiedError and StructuredLog string
   tests fail. Installed engine source confirms literal expected strings.
   Automation now passes -culture=en per process; the same startup tests pass.
   No engine files, system language or user editor preferences were changed.

# Test Result

PowerShell parser and native-process contract checks PASS: paths with spaces,
stdout/stderr capture, nonzero exit 17, bounded timeout with owned-tree termination.
Logged Unreal errors are also rejected. Evidence:
`artifacts/setup/tooling-tests-20261006-030952-b6be3343`.
Initialize-Lyra correctly rejects the non-Lyra template without writing to it.
The real C++ test `ArenaOfElements.Setup.ModuleLoads` was discovered and executed.
Final report: `artifacts/setup/tests-20261006-031137-61ff5af3/report/index.json`:
1 success, 0 failed, 0 not-run, no test errors/warnings. The test verifies the
host/Lyra module and explicitly loads ArenaOfElementsRuntime.
Collection copied 9 logs to `artifacts/setup/collected-logs-20261006-031010-45ad7aa5`.
An intentional nonexistent-test run was rejected despite the editor returning
exit 0: the log reported zero matching tests. Evidence:
`artifacts/setup/tests-20261006-031010-b0877ae7`. Zero-test success is not accepted.

# Git Status

Origin was empty at discovery. All setup changes use codex/setup-agent-environment;
no main branch push or history rewrite. Only authored setup files are included
in the setup commit. GameDirectory/Arena_of_Elements remains untracked user work.
Large generated logs/binaries/DDC are ignored. No downloaded Lyra assets are
included. The repository is public, so raw logs are intentionally kept local.

Expected post-commit `git status --short` (checked at delivery):

```text
?? GameDirectory/
```

The setup commit SHA and remote verification are reported in the final response.

# Remaining Warnings

- UBT reports missing Visual Studio SDK/editor IDE integration. Native command-line
  compilation succeeds; the full IDE/Unreal VS extension is optional for this setup.
- Low free memory limits compilation parallelism; no user applications were closed.
- Runtime feature is Installed only; GameFeatureData/experience activation is future
  work. Module load tests cannot prove Lyra feature activation or multiplayer.
- PIE, rendering/screenshots, bots and 3v3 have not been validated.
- Experimental Epic MCP is present in the engine but not enabled by setup.
- The interactive Launch-Editor command is prepared; startup was verified through
  the full editor's ExecutePythonScript path, not by opening another user window.
- Lyra integration can only be executed after the download. Its wrong-project
  rejection was tested; actual Lyra copying/configuration remains unverified.
- The Windows-only probe disables the default AndroidFileServer plugin to prevent
  irrelevant Android connection settings/tokens from being generated into Config.
  Generated probe input/IDE metadata is excluded. No such changes were made to
  the user's template or the future Lyra project.

# Human Actions Required

Download/create official Lyra Starter Game for UE 5.8 in
`GameDirectory/LyraStarterGame`, finish the download and close that Editor.
Exact steps are in HUMAN_ACTION_REQUIRED.md. This is the only requested manual
action; no dependency/toolchain installation is required by the observed build.

# Ready for Gameplay One-Shot

No. Complete Lyra integration and rerun every blocked gate before gameplay.
An isolated probe success never replaces validation of the selected project.

SETUP_STATUS=BLOCKED_HUMAN_ACTION
