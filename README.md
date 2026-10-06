# Arena of Elements

Autonomous Unreal Engine development environment preparation. Gameplay is not
implemented by this setup. **The selected foundation is Lyra for UE 5.8.**

Start with [setup status](docs/setup/SETUP_REPORT.md),
[required manual action](HUMAN_ACTION_REQUIRED.md) and
[canonical commands](Tools/README.md).

The runtime feature, editor-only smoke test plugin and Python checks are staged
under ArenaOfElements/ until official Lyra is available. Tools/ValidationHost is
an isolated toolchain probe, not the game. GameDirectory/Arena_of_Elements is a
separate user-created template and must not be mistaken for Lyra or overwritten.

After downloading Lyra, run Tools/Unreal/Initialize-Lyra.ps1 and all documented
validation commands. Consult [the next-agent handoff](docs/setup/NEXT_AGENT_HANDOFF.md)
before any gameplay implementation. No direct pushes to main.
