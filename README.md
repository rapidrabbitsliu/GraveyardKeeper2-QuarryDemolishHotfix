# Quarry Demolish Hotfix

A small BepInEx fix for the **Graveyard Keeper 2** quarry cave blocker.

In game version 1.005, finishing `quarry_cave_blocked_work` can leave the player unable to move. The `Building_QuarryBlock.demolish` flow tries to move the player to `gd_quarry_block_demolish`, but that point is missing. This plugin skips **only that movement step**, and only when the point is absent. The game's own flow then handles the explosion, removes the blocker, changes the cave points, and returns control to the player.

## Install

- Manual (available now): install BepInEx 5 for the game's Mono build, then put [`QuarryDemolishHotfix.dll`](plugins/QuarryDemolishHotfix.dll) in `BepInEx/plugins/QuarryDemolishHotfix/`.
- Thunderstore Mod Manager: once this package is published on Thunderstore, install it there and launch in **Modded** mode. The BepInEx pack is declared as a dependency.

Back up your save before attempting the quarry work interaction. If you are already stuck, reload a save where the blocker can still be worked on, then complete the interaction again. After it finishes, check that the blocker is gone, the mine entrance can be used, and the result survives saving and reloading.

This plugin does not edit save files, change quest flags directly, or suppress other movement errors. If the missing point is present in a future game update, the original movement runs unchanged. Remove the DLL when the game no longer needs the fix.

Tested on one Windows x64 save with game save version **1.005** and BepInEx **5.4.2305**. Other builds and previously saved broken states have not been verified.

## Source and build

The source is in [`src/QuarryDemolishHotfix.cs`](src/QuarryDemolishHotfix.cs). To compile on Windows, provide the game directory and the `BepInEx/core` directory:

```powershell
.\build.ps1 -GameDir 'C:\Path\To\Graveyard Keeper 2' -BepInExCoreDir 'C:\Path\To\BepInEx\core'
```

The script writes `build/QuarryDemolishHotfix.dll`. The `plugins/` DLL and `dist/` ZIP are the 1.0.1 files verified in-game. No game assemblies, logs, or saves are distributed here. This is an unofficial community fix.

## 中文说明

此补丁只处理采石场洞口拆除流程缺少 `gd_quarry_block_demolish` 点而卡住的情况。它跳过失效的角色移动步骤，后续拆除、洞口切换和控制权恢复仍由游戏原脚本完成。请先备份存档；完成后保存并重新读档，确认洞口可进入。本模组不会直接修改存档或任务状态。
