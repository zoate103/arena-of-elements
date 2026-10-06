# Arena of Elements

Autonomous Unreal Engine development environment preparation. Gameplay is not
implemented by this setup. **The selected foundation is Lyra for UE 5.8.**

Start with [setup status](docs/setup/SETUP_REPORT.md) and
[canonical commands](Tools/README.md). The downloaded project is
`GameDirectory/LyraStarterGame/LyraStarterGame/LyraStarterGame.uproject`.
Run `git lfs pull` after cloning to obtain the required binary assets.

The runtime feature, editor-only smoke test plugin and Python checks are integrated
into Lyra. ArenaOfElements/ retains the bootstrap template used by the isolated
Tools/ValidationHost probe. GameDirectory/Arena_of_Elements is a
separate user-created template and must not be mistaken for Lyra or overwritten.

Use the documented build and validation commands. Consult
[the next-agent handoff](docs/setup/NEXT_AGENT_HANDOFF.md)
before any gameplay implementation. No direct pushes to main.

Lyra and its included content retain Epic's licensing and attribution; this
repository does not relicense them. See [upstream provenance](docs/setup/UPSTREAM.md).
