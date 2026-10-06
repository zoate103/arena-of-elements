# Architecture preparation

The user selected official Lyra as the foundation on 2026-10-06. The separately
created C++ template in GameDirectory/Arena_of_Elements is preserved and is not
the selected game project.

The initial bootstrap layer remains at:

- ArenaOfElements/Plugins/GameFeatures/ArenaOfElements: runtime module with GAS,
  GameplayTags, GameplayTasks, GameFeatures and Niagara dependencies.
- ArenaOfElements/Plugins/Editor/ArenaSetupAutomation: editor-only automation
  discovery and module loading test (`ArenaOfElements.Setup.ModuleLoads`).
- ArenaOfElements/Content/Python/arena_setup: editor/content/asset smoke checks.

The layer is now installed under GameDirectory/LyraStarterGame/LyraStarterGame.
These installed copies are the canonical locations for subsequent development.
Initialize-Lyra remains a bootstrap helper for fresh downloads only. Preserve
LyraGame, LyraEditor and original systems; do not rename all Lyra sources.
The runtime feature is initially **Installed**, not activated. This establishes
a compiled code skeleton without inventing a GameFeatureData asset or gameplay.
The gameplay phase must create its GameFeatureData via supported editor APIs,
register the asset rules/experience integration and validate activation in Lyra.
The smoke test explicitly loads the module, which is not feature activation.

Future conceptual areas are Core, Characters, Combat, Abilities, Elements,
Movement, Arena, Match, AI, UI, VFX, Audio and Tests. Create them as needed rather
than adding empty files. No gameplay or combat implementation belongs in setup.

Git LFS patterns: .uasset, .umap, .ubulk, .uexp, .replay. Source, Config, Content/Python and
required content are tracked; Binaries, Intermediate, Saved and DDC are ignored.
No LFS history migration was performed. Consider actual asset sizes before adding
additional formats. Review licensing/access before publishing downloaded content.
