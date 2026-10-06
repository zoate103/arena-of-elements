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

These multiplayer scenarios are prepared, not yet executed. Lyra is now installed
at GameDirectory/LyraStarterGame/LyraStarterGame. No global editor settings or
unrelated project preferences were changed.

The downloaded Lyra's DefaultEditorPerProjectUserSettings.ini already enables
server network emulation with 30–60 ms incoming/outgoing latency and 1% packet
loss. Disable emulation in the local Play settings for the clean baseline, then
restore it for adverse-network checks; do not assume default PIE is lossless.
The file also enables GameGetsMouseControl and RouteGamepadToSecondWindow.

Actual map defaults: `/Game/System/DefaultEditorMap/L_DefaultEditorOverview` for
Editor, `/Game/System/FrontEnd/Maps/L_LyraFrontEnd` for game startup. Existing
experiences include `/ShooterMaps/Maps/L_Expanse` and `/ShooterCore/Maps/L_ShooterGym`.
The source LyraBotCreationComponent reads `?NumBots=<count>` for game modes and,
in Editor, LyraDeveloperSettings.bOverrideBotCount / OverrideNumPlayerBotsToSpawn.
These are existing Lyra controls, not newly implemented gameplay. Account for
humans plus bots when validating a six-participant match.

Use Launch-Editor for interactive PIE; collect Saved/Logs afterward. Python
commandlets cannot prove interactive PIE correctness. Rendering/screenshots require
a real RHI (`Run-Python -FullEditor -Render`) and a loaded level/camera; wait for
asynchronous screenshot completion before quitting. NullRHI evidence contains no
visual proof. Dedicated-server packaging may require an Epic source-engine build;
assess that separately after local gameplay validation, not during this setup.
