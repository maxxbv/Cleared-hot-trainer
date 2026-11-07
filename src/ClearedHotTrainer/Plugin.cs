using System.Reflection;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using BepInEx;
using BepInEx.Configuration;
using BepInEx.Unity.IL2CPP;
using HarmonyLib;

namespace ClearedHot.LocalAssist;

[BepInPlugin(Id, "Cleared Hot Trainer", "0.1.1-alpha")]
public sealed class Plugin : BasePlugin
{
    public const string Id = "local.clearedhot.assist";
    internal static Plugin? Instance;
    internal static bool Running;
    internal static ConfigEntry<bool> God = null!, Ammo = null!, Heat = null!;
    private readonly Harmony harmony = new(Id);
    private static readonly HashSet<string> failures = new();

    public override void Load()
    {
        Instance = this;
        God = Config.Bind("Features", "GodMode", true, "Protect only the current player helicopter.");
        Ammo = Config.Bind("Features", "InfiniteAmmo", true, "Prevent consumption of the player's generic weapon ammunition.");
        Heat = Config.Bind("Features", "NoOverheat", true, "Prevent player minigun overheating.");
        try
        {
            VerifyGame(Paths.GameRootPath);
            Install();
            Running = true;
            Log.LogInfo($"Patches registered. GodMode={God.Value}, InfiniteAmmo={Ammo.Value}, NoOverheat={Heat.Value}. Waiting for player. Runtime/gameplay NOT yet validated.");
        }
        catch (Exception e)
        {
            Running = false;
            harmony.UnpatchSelf();
            Log.LogError($"Plugin disabled; no patches retained. {e}");
        }
    }

    // No game type is touched until the exact original files have been checked.
    internal static void VerifyGame(string root)
    {
        var expected = new Dictionary<string, string>
        {
            ["GameAssembly.dll"] = "391678F4EE191CE0498BD99CBC7DD67AC6D3DC665B061EDFAAFAE5F71B7EE82C",
            ["ClearedHot_Data/il2cpp_data/Metadata/global-metadata.dat"] = "F8F2D2BD90507D1EFF601988596178C3DD3CFF2E61F2F652D3531BD25F71D06D"
        };
        foreach (var pair in expected)
        {
            using var stream = File.OpenRead(Path.Combine(root, pair.Key));
            using var sha = SHA256.Create();
            string actual = Convert.ToHexString(sha.ComputeHash(stream));
            if (actual != pair.Value) throw new InvalidOperationException($"Unsupported game build: {pair.Key}; SHA256={actual}");
            Instance?.Log.LogInfo($"Verified {pair.Key}: {actual}");
        }
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    private void Install() => Patches.Install(harmony);

    internal static void Fault(string location, Exception error)
    {
        // Fail open on unexpected native/interop behavior; never keep guessing at targets.
        Running = false;
        if (failures.Add(location)) Instance?.Log.LogError($"Protection disabled after {location}: {error}");
    }

    public override bool Unload()
    {
        Running = false;
        harmony.UnpatchSelf();
        Instance = null;
        return true;
    }
}
