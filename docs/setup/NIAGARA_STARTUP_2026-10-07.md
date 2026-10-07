# Niagara editor startup incident — 2026-10-07

The first interactive UE 5.8.1 start crashed while loading Lyra's overview map.
The crash log reports null linked pins in NE_ImpactSparks followed by a null-address
access violation in NiagaraEditor. The initial setup's NullRHI/subsystem checks
did not establish graphical startup reliability. Raw crash data stays local under
the project's Saved/Crashes; account identifiers are not copied into this report.

## Findings and mitigation

The downloaded DefaultEngine.ini enabled both s.AsyncLoadingThreadEnabled and
s.AllowMultithreadedLoading in /Script/Engine.EditorStreamingSettings, while
explicitly disabling both for commandlets. Installed AsyncLoading2.cpp confirms
that distinction. Loading NE_ImpactSparks alone succeeded in commandlets both
with NullRHI and with graphics enabled. A warm interactive restart with the old
parallel settings also completed in 38.396 seconds. The original crash was
therefore not reproduced deterministically; load-order sensitivity is a working
explanation, not a proven engine root cause or proof of a corrupt asset.

Set the two editor-only loading options to False as a conservative mitigation.
The engine's separate packaged-runtime streaming settings are unchanged. No
Niagara asset was removed, replaced, edited as binary, or resaved. Engine code,
graphics driver and global cache were not changed. The old config has an ignored
local .backup-niagara-startup-20261007 copy. Existing editor processes retain
their startup settings until restarted; the already reopened user editor was
left running to preserve its state.

Added validate_startup_map.py to explicitly load L_DefaultEditorOverview, verify
the actual editor world and load the NE_ImpactSparks NiagaraEmitter. It never
saves assets. Added Run-Python -Isolated, which uses Unreal's supported -UserDir
override for per-run Saved/Intermediate/user settings, avoiding the interactive
editor's search database lock. Source, Config and Content remain in the project.

## Executed checks

All evidence directories below are under artifacts/setup.

| Check | Result | Evidence |
| --- | --- | --- |
| Impact emitter alone, NullRHI commandlet | PASS, exit 0 | python-20261007-023543-02d05fd5 |
| Impact emitter alone, rendered commandlet | PASS, exit 0 | python-20261007-023719-a5525531 |
| Full rendered editor, explicit startup map and emitter | Assets loaded, native exit 0; strict wrapper FAIL on other logged errors | python-20261007-023856-ff6b7acd |
| Full editor, isolated user data, NullRHI, explicit map/emitter | PASS, exit 0, completion markers, no logged errors | python-20261007-024136-521d36ab |
| Rendered commandlet, isolated user data, explicit map/emitter | PASS, exit 0, completion markers, no logged errors | python-20261007-024254-665de12f |
| PowerShell/tooling contracts | PASS | tooling-tests-20261007-024209-3407e402 |
| UAT builds/discovers Lyra automation module | PASS, exit 0; Lyra commands listed | uat-validation-20261007-024440-d1d64f5d |

The successful full-editor test confirms Async Loading Thread: false and
Multithreaded: false. Graphics-enabled loading is now exercised explicitly, but
these checks do not prove first-run shader-cache behavior, effect visual quality,
PIE or multiplayer. No C++ gameplay changes required a new LyraEditor compilation.

```powershell
.\Tools\Unreal\Run-Python.ps1 -Script validate_startup_map.py -FullEditor -Isolated
.\Tools\Unreal\Run-Python.ps1 -Script validate_startup_map.py -Render -Isolated
```

## Other startup diagnostics

The full rendered editor run loaded the map and emitter successfully, but its
strict wrapper correctly rejected two other logged errors. No check was weakened:

- Saved/Search was locked by the already open interactive editor. Per-run -Isolated
  user data addresses that collision for future automation.
- PixelStreaming2RTC reported "Cannot set target window - GEngine is not valid."
  The installed RTCInputHandler.cpp constructor emits this when casting GEngine
  to UGameEngine fails; a regular editor uses an editor engine. This separate
  stock-plugin diagnostic remains unresolved. Do not claim the full rendered
  editor's strict log check passed, or suppress other errors to hide it.

Interactive startup also exposed CS0579 duplicate assembly attributes in
Lyra.Automation.csproj. UAT uses uatobj while direct SDK evaluation uses obj;
each could discover the other's generated C# through the default glob. The
project now excludes obj, uatobj and bin C# from that glob. Both intermediate
directories are preserved locally. Eighteen generated uatobj files and the
machine-specific Lyra.Automation.csproj.props were removed from Git tracking and
ignored. UAT supplies EngineDir itself (EpicGames.MsBuild/CsProjBuilder.cs), so
the local props file is not required in the shared repository.

An initial direct SDK validation without building project references failed on
missing engine reference assemblies; it is not a successful test. The final
validation used Unreal's own AutomationTool -ScriptsForProject=... -List -NoP4,
which rebuilt one project in 27.45 seconds and discovered Lyra_UpdateAuditCollections
and LyraContentValidation with exit 0. It did not package or deploy anything.
