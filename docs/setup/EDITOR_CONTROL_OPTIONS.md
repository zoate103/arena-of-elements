# Editor control and MCP audit

Built-in tooling already supports file/source edits, UBT builds, commandlet/full
editor Python, asset registry inspection, asset creation/save/delete, editor
subsystems, automation tests and logs. The setup uses these facilities.

Interactive viewport operation, window management, some PIE orchestration and
visual evidence still need full editor/rendering or reviewed editor-control APIs.
Python availability in the editor does not make Python a runtime gameplay API.

Detected in the installed UE 5.8.1 engine:
`Engine/Plugins/Experimental/ModelContextProtocol/ModelContextProtocol.uplugin`.
Descriptor publisher: Epic Games, Inc.; version 1.0; experimental; NoRedist;
EnabledByDefault=false. Modules include Runtime, Editor and UncookedOnly components.
It depends on EngineAssetDefinitions and ToolsetRegistry. The unrelated ArenaGame
project enables it; this setup does not modify that project. No community MCP was
installed, and this setup does not enable MCP or start a remote-control listener.

An MCP might simplify future GUI/PIE tasks but is unnecessary for the verified
command-line foundation. Descriptor inspection is a limited audit, not a security
approval. Before enabling it: inspect the installed implementation, bind only to
intended local interfaces, require suitable authentication/access control, constrain
filesystem and command execution, review logging and secrets, assess NoRedist
and experimental/runtime packaging implications, and verify teardown behavior.

The subsequently downloaded Lyra 5.8 project already enables Epic's AIAssistant,
ToolsetRegistry and AllToolsets. These were present in the downloaded descriptor,
not installed or enabled by this setup. AllToolsets is EditorOnly, experimental
and NoRedist in the installed engine; its dependencies include MCPClientToolset.
No credentials, external MCP connections or remote-control endpoints were
configured by this setup. Reassess these optional stock editor plugins before
packaging or opening any remote-control access. Engine binaries/source are not
part of the Git baseline.

The downloaded project also contains LyraExtTool. Its descriptor has an empty
publisher field, but source copyright identifies Epic. Inspection found an empty
startup/shutdown module and a Blueprint helper for changing mesh materials; no
network or startup command-execution logic was observed. It was preserved.

References consulted:
- https://dev.epicgames.com/documentation/en-us/unreal-engine/scripting-the-unreal-editor-using-python
- https://dev.epicgames.com/documentation/en-us/unreal-engine/run-automation-tests-in-unreal-engine
- https://dev.epicgames.com/documentation/en-us/unreal-engine/lyra-sample-game-in-unreal-engine

The installed engine source/descriptors take precedence for exact 5.8.1 behavior.
