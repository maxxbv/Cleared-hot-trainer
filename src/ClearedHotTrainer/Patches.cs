using System.Reflection;
using Cfinger.KAS;
using Cfinger.KAS.Helo;
using Cfinger.KAS.Toolkit;
using HarmonyLib;

namespace ClearedHot.LocalAssist;

internal static class Patches
{
    private static readonly HashSet<string> observed = new();
    internal static void ResetDiagnostics() => observed.Clear();
    private static void Trace(string feature)
    {
        if (observed.Add(feature)) Plugin.Instance?.Log.LogInfo($"Observed player interception: {feature}");
    }
    internal static void Install(Harmony harmony)
    {
        Bind(harmony, typeof(PlayerHeloController), "Awake", Type.EmptyTypes, postfix: nameof(Observe));
        Bind(harmony, typeof(PlayerHeloController), "OnEnable", Type.EmptyTypes, postfix: nameof(Observe));
        Bind(harmony, typeof(PlayerHeloController), "Update", Type.EmptyTypes, postfix: nameof(Observe));
        Bind(harmony, typeof(PlayerHeloController), "SwapHeloControl", new[] { typeof(UnityEngine.GameObject), typeof(bool) }, postfix: nameof(Observe));
        Bind(harmony, typeof(PlayerHeloController), "OnDisable", Type.EmptyTypes, postfix: nameof(Forget));
        Bind(harmony, typeof(HealthController), "TakeDamage", new[] { typeof(float) }, prefix: nameof(AllowDamage));
        Bind(harmony, typeof(HealthController), "TakeDamage", new[] { typeof(DamageData) }, prefix: nameof(AllowDamage));
        Bind(harmony, typeof(HealthController), "InternalTakeDamage", new[] { typeof(DamageData) }, prefix: nameof(AllowDamage));
        Bind(harmony, typeof(HealthController), "Kill", Type.EmptyTypes, prefix: nameof(AllowDamage));
        Bind(harmony, typeof(HealthController), "SetHealthInternal", new[] { typeof(float), typeof(bool) }, prefix: nameof(AllowHealthChange));
        Bind(harmony, typeof(HeloController), "OnHeloDestroyed", Type.EmptyTypes, prefix: nameof(AllowDestruction));
        Bind(harmony, typeof(HeloRotorDeathController), "HandleRotorDeath", Type.EmptyTypes, prefix: nameof(AllowRotorDeath));
        Bind(harmony, typeof(HeloInventoryGenericAmmo), "ConsumeItem", Type.EmptyTypes, prefix: nameof(AllowConsume));
        Bind(harmony, typeof(HeloInventoryGenericAmmo), "GetNumItems", Type.EmptyTypes, postfix: nameof(AvailableAmmo));
        Bind(harmony, typeof(HeloInventoryManager), "GetNumOfType", new[] { typeof(HeloInventoryItemTypeSO) }, postfix: nameof(MissingWeaponAmmo));
        Bind(harmony, typeof(HeloDeviceMinigun), "ProcessOverheatStatus", new[] { typeof(float) }, prefix: nameof(ProcessHeat));
        Bind(harmony, typeof(HeloDeviceMinigun), "FixedUpdate", Type.EmptyTypes, prefix: nameof(ClearHeat), postfix: nameof(ClearHeat));
    }

    private static void Bind(Harmony harmony, Type type, string name, Type[] args,
        string? prefix = null, string? postfix = null)
    {
        var method = type.GetMethod(name, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance,
            null, args, null) ?? throw new MissingMethodException(type.FullName, name);
        HarmonyMethod? Hook(string? hook) => hook == null ? null : new HarmonyMethod(
            typeof(Patches).GetMethod(hook, BindingFlags.Static | BindingFlags.NonPublic)
            ?? throw new MissingMethodException(nameof(Patches), hook));
        harmony.Patch(method, Hook(prefix), Hook(postfix));
        Plugin.Instance?.Log.LogInfo($"Patched {type.FullName}.{name}({string.Join(",", args.Select(t => t.Name))})");
    }

    private static void Observe(PlayerHeloController __instance)
    {
        if (!Plugin.Running) return;
        try { PlayerScope.Observe(__instance); }
        catch (Exception e) { Plugin.Fault(nameof(Observe), e); }
    }

    private static void Forget(PlayerHeloController __instance)
    {
        if (!Plugin.Running) return;
        try { PlayerScope.Forget(__instance); }
        catch (Exception e) { Plugin.Fault(nameof(Forget), e); }
    }

    private static bool AllowDamage(HealthController __instance)
    {
        if (!Plugin.Running || !Plugin.God.Value) return true;
        try
        {
            if (!PlayerScope.Health(__instance)) return true;
            Trace("damage/kill"); return false;
        }
        catch (Exception e) { Plugin.Fault(nameof(AllowDamage), e); return true; }
    }

    private static bool AllowHealthChange(HealthController __instance, float __0)
    {
        if (!Plugin.Running || !Plugin.God.Value) return true;
        try
        {
            return !PlayerScope.Health(__instance) ||
                !ProtectionPolicy.BlockHealthDecrease(__instance.health, __0);
        }
        catch (Exception e) { Plugin.Fault(nameof(AllowHealthChange), e); return true; }
    }

    private static bool AllowDestruction(HeloController __instance)
    {
        if (!Plugin.Running || !Plugin.God.Value) return true;
        try { return !PlayerScope.Owns(__instance); }
        catch (Exception e) { Plugin.Fault(nameof(AllowDestruction), e); return true; }
    }

    private static bool AllowRotorDeath(HeloRotorDeathController __instance)
    {
        if (!Plugin.Running || !Plugin.God.Value) return true;
        try { return !PlayerScope.Health(__instance.healthController); }
        catch (Exception e) { Plugin.Fault(nameof(AllowRotorDeath), e); return true; }
    }

    private static bool AllowConsume(HeloInventoryGenericAmmo __instance)
    {
        if (!Plugin.Running || !Plugin.Ammo.Value) return true;
        try
        {
            if (!PlayerScope.Ammo(__instance)) return true;
            Trace("ammo consumption"); return false;
        }
        catch (Exception e) { Plugin.Fault(nameof(AllowConsume), e); return true; }
    }

    private static void AvailableAmmo(HeloInventoryGenericAmmo __instance, ref int __result)
    {
        if (!Plugin.Running || !Plugin.Ammo.Value) return;
        try
        {
            if (PlayerScope.Ammo(__instance))
            {
                __result = ProtectionPolicy.AvailableAmmo(__result, __instance.maxAmmo);
                Trace("ammo availability");
            }
        }
        catch (Exception e) { Plugin.Fault(nameof(AvailableAmmo), e); }
    }

    private static void ClearHeat(HeloDeviceMinigun __instance)
    {
        if (!Plugin.Running || !Plugin.Heat.Value) return;
        try
        {
            if (!PlayerScope.Gun(__instance)) return;
            __instance.overheatTimer = 0;
            if (__instance.overheated) __instance.SetOverheated(false);
        }
        catch (Exception e) { Plugin.Fault(nameof(ClearHeat), e); }
    }

    private static void MissingWeaponAmmo(HeloInventoryManager __instance, HeloInventoryItemTypeSO __0, ref int __result)
    {
        if (!Plugin.Running || !Plugin.Ammo.Value || __result > 0) return;
        try
        {
            if (!PlayerScope.EquippedWeaponAmmo(__instance, __0)) return;
            __result = ProtectionPolicy.AvailableAmmo(__result, __0.maxAmmo);
            Trace("equipped weapon ammo availability without stock/entry");
        }
        catch (Exception e) { Plugin.Fault(nameof(MissingWeaponAmmo), e); }
    }

    private static bool ProcessHeat(HeloDeviceMinigun __instance)
    {
        if (!Plugin.Running || !Plugin.Heat.Value) return true;
        try
        {
            if (!PlayerScope.Gun(__instance)) return true;
            Trace("overheat processing");
            __instance.overheatTimer = 0;
            if (__instance.overheated) __instance.SetOverheated(false);
            return false;
        }
        catch (Exception e) { Plugin.Fault(nameof(ProcessHeat), e); return true; }
    }
}
