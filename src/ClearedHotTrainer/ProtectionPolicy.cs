namespace ClearedHot.LocalAssist;
internal static class ProtectionPolicy
{
    internal static bool Owns(nint helo, nint player, nint playersHelo) =>
        player != 0 && Same(helo, playersHelo);
    internal static bool Same(nint first, nint second) => first != 0 && first == second;
    internal static bool BlockHealthDecrease(float current, float proposed) =>
        !float.IsFinite(proposed) || proposed <= 0 || proposed < current;
    internal static int AvailableAmmo(int current, int capacity) =>
        System.Math.Max(1, System.Math.Max(current, capacity));
}
