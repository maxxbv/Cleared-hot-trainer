using System.Reflection;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;

internal static class ContractChecks
{
    internal static int Run(string wrapper, string plugin)
    {
        using var pe = new PEReader(File.OpenRead(wrapper));
        var reader = pe.GetMetadataReader();
        int count = 0;
        void Require(string type, string method, params string[] parameters)
        {
            var td = reader.TypeDefinitions.Select(reader.GetTypeDefinition).Single(t =>
                (reader.GetString(t.Namespace) is var ns && ns.Length > 0 ? ns + "." : "") + reader.GetString(t.Name) == type);
            var candidates = td.GetMethods().Select(reader.GetMethodDefinition).Where(m => reader.GetString(m.Name) == method);
            if (!candidates.Any(m => m.DecodeSignature(new Names(), (object?)null).ParameterTypes.SequenceEqual(parameters)))
                throw new Exception($"Missing exact method: {type}.{method}({string.Join(",", parameters)})");
            count++;
            Console.WriteLine($"PASS contract: {type}.{method}({string.Join(",", parameters)})");
        }
        const string player = "Cfinger.KAS.PlayerHeloController", health = "Cfinger.KAS.Toolkit.HealthController";
        foreach (string m in new[] { "Awake", "OnEnable", "OnDisable", "Update" }) Require(player, m);
        Require(player, "SwapHeloControl", "UnityEngine.GameObject", "Boolean");
        Require(health, "TakeDamage", "Single");
        Require(health, "TakeDamage", "Cfinger.KAS.DamageData");
        Require(health, "InternalTakeDamage", "Cfinger.KAS.DamageData");
        Require(health, "Kill");
        Require(health, "SetHealthInternal", "Single", "Boolean");
        Require("Cfinger.KAS.HeloController", "OnHeloDestroyed");
        Require("Cfinger.KAS.HeloRotorDeathController", "HandleRotorDeath");
        Require("Cfinger.KAS.Helo.HeloInventoryGenericAmmo", "ConsumeItem");
        Require("Cfinger.KAS.Helo.HeloInventoryGenericAmmo", "GetNumItems");
        Require("Cfinger.KAS.HeloInventoryManager", "GetNumOfType", "Cfinger.KAS.Helo.HeloInventoryItemTypeSO");
        Require("HeloDeviceMinigun", "ProcessOverheatStatus", "Single");
        Require("HeloDeviceMinigun", "FixedUpdate");
        bool rejected = false;
        try { Require(health, "MethodThatDoesNotExist"); } catch (Exception) { rejected = true; }
        if (!rejected) throw new Exception("Missing method was accepted");
        Console.WriteLine("PASS contract: nonexistent method rejected"); count++;
        using var dll = new PEReader(File.OpenRead(plugin));
        if (dll.PEHeaders.CoffHeader.Machine != Machine.Amd64) throw new Exception("Plugin must target AMD64");
        var metadata = dll.GetMetadataReader();
        if (metadata.GetString(metadata.GetAssemblyDefinition().Name) != "ClearedHot.LocalAssist") throw new Exception("Wrong assembly");
        if (!metadata.TypeDefinitions.Select(metadata.GetTypeDefinition).Any(t => metadata.GetString(t.Name) == "Plugin")) throw new Exception("Missing plugin type");
        Console.WriteLine("PASS artifact: plugin assembly and AMD64 PE header"); count++;
        return count;
    }

    private sealed class Names : ISignatureTypeProvider<string, object?>
    {
        public string GetArrayType(string e, ArrayShape shape) => e + "[]";
        public string GetByReferenceType(string e) => e + "&";
        public string GetFunctionPointerType(MethodSignature<string> signature) => "fnptr";
        public string GetGenericInstantiation(string t, System.Collections.Immutable.ImmutableArray<string> a) => t + "<" + string.Join(",", a) + ">";
        public string GetGenericMethodParameter(object? c, int i) => "!!" + i;
        public string GetGenericTypeParameter(object? c, int i) => "!" + i;
        public string GetModifiedType(string mod, string t, bool required) => t;
        public string GetPinnedType(string t) => t;
        public string GetPointerType(string e) => e + "*";
        public string GetPrimitiveType(PrimitiveTypeCode code) => code.ToString();
        public string GetSZArrayType(string e) => e + "[]";
        public string GetTypeFromDefinition(MetadataReader r, TypeDefinitionHandle h, byte kind)
        { var t = r.GetTypeDefinition(h); var ns = r.GetString(t.Namespace); return (ns.Length == 0 ? "" : ns + ".") + r.GetString(t.Name); }
        public string GetTypeFromReference(MetadataReader r, TypeReferenceHandle h, byte kind)
        { var t = r.GetTypeReference(h); var ns = r.GetString(t.Namespace); return (ns.Length == 0 ? "" : ns + ".") + r.GetString(t.Name); }
        public string GetTypeFromSpecification(MetadataReader r, object? context, TypeSpecificationHandle h, byte kind) => r.GetTypeSpecification(h).DecodeSignature(this, context);
    }
}
