using ClearedHot.LocalAssist;

int passed = 0;
void Check(bool actual, string name) { if (!actual) throw new Exception("FAIL: " + name); passed++; Console.WriteLine("PASS: " + name); }
// A stale helo pointer, missing reciprocal link, or unrelated native object must never be accepted.
Check(!ProtectionPolicy.Owns((nint)10, 0, (nint)10), "missing player denied");
Check(!ProtectionPolicy.Owns(0, (nint)20, 0), "null helo denied");
Check(!ProtectionPolicy.Owns((nint)10, (nint)20, (nint)11), "previous helo denied after swap");
Check(ProtectionPolicy.Owns((nint)11, (nint)20, (nint)11), "new helo accepted after swap");
Check(!ProtectionPolicy.Same((nint)10, 0), "null target denied");
Check(!ProtectionPolicy.Same((nint)10, (nint)11), "enemy pointer denied");
Check(ProtectionPolicy.Same((nint)10, (nint)10), "different wrappers of same native object accepted");
Check(ProtectionPolicy.BlockHealthDecrease(50, 49), "damage decrease blocked");
Check(ProtectionPolicy.BlockHealthDecrease(50, 0), "scripted kill blocked");
Check(!ProtectionPolicy.BlockHealthDecrease(50, 60), "healing allowed");
Check(!ProtectionPolicy.BlockHealthDecrease(50, 50), "unchanged health allowed");
Check(ProtectionPolicy.BlockHealthDecrease(50, float.NaN), "invalid health rejected");
Check(ProtectionPolicy.AvailableAmmo(0, 0) == 1, "empty inventory permits first shot");
Check(ProtectionPolicy.AvailableAmmo(3, 8) == 8, "normal max capacity exposed");
Check(ProtectionPolicy.AvailableAmmo(12, 8) == 12, "over-capacity ammo preserved");
Check(ProtectionPolicy.AvailableAmmo(-5, -1) == 1, "invalid ammo capacity remains positive");
Console.WriteLine($"{passed} policy checks passed. These checks do not execute Unity or IL2CPP.");
if (args.Length == 2)
    Console.WriteLine($"{ContractChecks.Run(args[0], args[1])} static contract/artifact checks passed.");
