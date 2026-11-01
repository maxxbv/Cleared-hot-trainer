using Cfinger.KAS;
using Cfinger.KAS.Helo;
using Cfinger.KAS.Toolkit;
using Il2CppInterop.Runtime.InteropTypes;

namespace ClearedHot.LocalAssist;

internal static class PlayerScope
{
    private static nint reportedPlayerHelo;
    internal static bool Same(Il2CppObjectBase? first, Il2CppObjectBase? second) =>
        ProtectionPolicy.Same(first?.Pointer ?? IntPtr.Zero, second?.Pointer ?? IntPtr.Zero);

    internal static bool Owns(HeloController? helo)
    {
        if (!Plugin.Running || helo == null || helo.isDestroyed) return false;
        var player = helo.player;
        if (player == null || !player.isActiveAndEnabled) return false;
        // Manual controls may be disabled during cutscenes: retain protection then.
        return ProtectionPolicy.Owns(helo.Pointer, player.Pointer, player.heloController?.Pointer ?? IntPtr.Zero);
    }

    internal static bool Health(HealthController health)
    {
        var helo = health.GetComponentInParent<HeloController>();
        if (!Owns(helo)) return false;
        if (Same(health, helo.mainHealth) || Same(health, helo.healthMaster)) return true;
        var manager = helo.heloDamageManager;
        if (manager == null) return false;
        var components = manager.healthControllers;
        if (components == null) return false;
        for (int i = 0; i < components.Count; i++)
            if (Same(health, components[i])) return true;
        // A passenger, carried enemy, or unrelated child health is not protected.
        return false;
    }

    internal static bool Ammo(HeloInventoryGenericAmmo item)
    {
        var inventory = item.heloInventoryManager;
        if (inventory == null) return false;
        var helo = inventory.GetComponentInParent<HeloController>();
        return Owns(helo) && Same(inventory, helo.inventory);
    }

    internal static bool Gun(HeloDeviceMinigun gun) => Owns(gun.heloController);

    internal static bool EquippedWeaponAmmo(HeloInventoryManager inventory, HeloInventoryItemTypeSO itemType)
    {
        if (itemType == null) return false;
        var helo = inventory.GetComponentInParent<HeloController>();
        if (!Owns(helo) || !Same(inventory, helo.inventory)) return false;
        var devices = helo.GetComponentsInChildren<HeloDevice>(true);
        for (int i = 0; i < devices.Length; i++)
        {
            var device = devices[i];
            if (device == null || !Same(device.heloController, helo) || !Same(device.inventoryItemType, itemType)) continue;
            if (device.TryCast<HeloDeviceMinigun>() != null || device.TryCast<HeloDeviceMissileLauncher>() != null)
                return true;
        }
        return false;
    }

    internal static void Observe(PlayerHeloController player)
    {
        var helo = player.heloController;
        if (!Owns(helo) || !Same(player, helo.player)) return;
        if (reportedPlayerHelo == helo.Pointer) return;
        reportedPlayerHelo = helo.Pointer;
        Patches.ResetDiagnostics();
        Plugin.Instance?.Log.LogInfo($"Player helicopter acquired: native=0x{helo.Pointer.ToInt64():X}. Protection follows current reciprocal owner link; no enemy-wide patches.");
    }

    internal static void Forget(PlayerHeloController player)
    {
        if (player.heloController != null && reportedPlayerHelo == player.heloController.Pointer)
        {
            reportedPlayerHelo = 0;
            Plugin.Instance?.Log.LogInfo("Player disabled; target will be resolved again when enabled.");
        }
    }
}
