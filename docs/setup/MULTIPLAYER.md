# Local multiplayer validation after Lyra integration

No production backend or dedicated server package is needed for the first slice.
Use an actual playable Lyra experience/map and the editor Play dropdown's advanced
settings (LevelEditorPlaySettings). Record map, experience, net mode, players,
single-process choice, build revision and logs for every run.

| Scenario | Configuration | Evidence |
| --- | --- | --- |
| Single player | Standalone PIE, 1 player | Possession, startup and clean exit |
| Listen server | Play As Listen Server, 2 players | Server authority and client replication |
| Multiple clients | Listen server with 3+ players; repeat without Run Under One Process | Independent client logs and replicated state |
| 3v3 | Listen server, 6 players total, experience supporting two teams | Team assignments, joins, respawns, replicated outcomes |
| Bots | Use Lyra's selected experience and its existing bot-spawning configuration | Authority-side spawning, correct team/player count |

Do not claim 3v3 or bots work merely because six windows open. Verify team sizes,
player/bot accounting and authoritative outcomes. Keep UI free of authority logic.
After baseline success, use controlled network lag/loss and record settings.
Single-process PIE is convenient but must not be the only multiplayer check.

These steps are prepared, not executed: Lyra is absent. No global editor settings
or unrelated project preferences were changed. Keep machine-specific PIE settings
out of tracked runtime config until verified against the actual Lyra version.

Use Launch-Editor for interactive PIE; collect Saved/Logs afterward. Python
commandlets cannot prove interactive PIE correctness. Rendering/screenshots require
a real RHI (`Run-Python -FullEditor -Render`) and a loaded level/camera; wait for
asynchronous screenshot completion before quitting. NullRHI evidence contains no
visual proof. Dedicated-server packaging may require an Epic source-engine build;
assess that separately after local gameplay validation, not during this setup.
