# Arena of Elements

Environment preparation only until a separate gameplay implementation request.
Read docs/setup/SETUP_REPORT.md and NEXT_AGENT_HANDOFF.md before working.
The actual foundation is official Lyra for UE 5.8. The validation host is a separate
tooling probe; use the real Lyra project for all normal acceptance gates.

## Architecture

The actual project is GameDirectory/LyraStarterGame/LyraStarterGame/LyraStarterGame.uproject.
Preserve this user-selected directory and the original Lyra module names.
The user explicitly selected Lyra instead of the unrelated template in
GameDirectory/Arena_of_Elements/. Preserve that template; do not commit it as Lyra.
ArenaOfElements/ retains the initial bootstrap layer for the isolated validation
host. The canonical gameplay/editing location is now inside the Lyra project.
Do not rerun Initialize-Lyra over divergent implementation files; it intentionally
refuses overwrites. Use that command only to bootstrap a fresh official download.
Add game features in the Lyra project's Plugins/GameFeatures/ArenaOfElements/.
Use server-authoritative gameplay, GAS for abilities/effects, GameplayTags for
semantic state, and data-driven elemental rules. Keep gameplay out of UI.
Preserve Lyra core unless a specific change is necessary. Maintain replication
correctness. Important systems require meaningful tests.

## Git

Use scoped commits on codex/* branches. Never push directly to main, force push,
or destructively reset unrelated work. Preserve user assets and changes.
Unreal binary assets use Git LFS. Do not commit generated output or credentials.

## Validation

Use PowerShell 7 and Tools/README.md commands. Consider Editor build, automation
tests, Unreal logs, replication and actual editor/runtime behavior for each
meaningful change. Never treat file existence or a zero-tests run as a pass.
Python is editor tooling only. Do not add unreviewed remote editor-control plugins.
Keep evidence under artifacts/setup; update setup reports honestly when blocked.

# BEGIN codex-control-center-mobile-question-hook
Wenn ein Planmodus-Aufruf von `request_user_input` mit einem Ergebnis beginnt, das den Präfix `CONTROL_CENTER_MOBILE_ANSWERS=` trägt, behandle den JSON-Inhalt als verbindliche Benutzerantwort. Wiederhole die Frage nicht und fahre mit dem Turn fort. Wenn kein solches Ergebnis vorliegt, verwende den normalen Planmodus-Fragefluss.
# END codex-control-center-mobile-question-hook
