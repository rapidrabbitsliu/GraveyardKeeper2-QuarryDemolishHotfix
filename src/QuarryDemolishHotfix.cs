using BepInEx;
using FlowCanvas;
using HarmonyLib;
using GK2.FlowCanvasNodes;

namespace QuarryDemolishHotfix
{
    [BepInPlugin("local.quarry-demolish-hotfix", "Quarry Demolish Hotfix", "1.0.1")]
    public sealed class Plugin : BaseUnityPlugin
    {
        private Harmony harmony;

        private void Awake()
        {
            harmony = new Harmony("local.quarry-demolish-hotfix");
            harmony.PatchAll(typeof(Plugin).Assembly);
            Logger.LogInfo("Quarry demolish hotfix loaded");
        }

        private void OnDestroy()
        {
            if (harmony != null) harmony.UnpatchSelf();
        }

        [HarmonyPatch(typeof(Flow_GoTo), "GoTo")]
        private static class MissingQuarryPointPatch
        {
            private const string PointId = "gd_quarry_block_demolish";

            private static bool Prefix(
                Flow flow,
                bool ___movePlayer,
                bool ___useGdDataInsteadId,
                ValueInput<string> ___gdPointId,
                FlowOutput ___onFinish)
            {
                if (!___movePlayer || ___useGdDataInsteadId)
                    return true;

                if (___gdPointId == null || ___gdPointId.value != PointId) return true;

                var save = MainGame.Instance.GameSave;
                if (save == null || save.worldData == null || save.worldData.gdPointsData == null)
                    return true;
                if (save.worldData.gdPointsData.GetGDPointDataById(PointId) != null)
                    return true;

                if (___onFinish == null) return true;

                BepInEx.Logging.Logger.CreateLogSource("QuarryDemolishHotfix")
                    .LogWarning("Missing quarry demolish point; skipping only the move and continuing the demolish flow.");
                ___onFinish.Call(flow);
                return false;
            }
        }
    }
}
