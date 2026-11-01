# Desenvolvimento

## Ambiente e dependências

Windows x64, PowerShell 7, Git e SDK .NET 8.0.427. global.json permite somente atualização de patch compatível. Plugin net6.0; testes net8.0.

Os scripts procuram work/tools/dotnet/dotnet.exe e depois dotnet no PATH; -DotNetPath permite seleção explícita. Runtimes sem SDK não bastam. DOTNET_CLI_HOME e cache NuGet ficam em work. NuGet.config usa nuget.org, sem tokens.

| Parâmetro | Referências |
|---|---|
| -GameReferencePath | Wrappers reais, incluindo Cfinger.Runtime.dll, UnityEngine.CoreModule.dll e Il2Cppmscorlib.dll |
| -BepInExCorePath | BepInEx.Core.dll, BepInEx.Unity.IL2CPP.dll e 0Harmony.dll de distribuição oficial |
| -InteropReferencePath | Il2CppInterop.Runtime.dll 1.5.3 usado na compilação analisada |

As referências usam Private=false e não entram na distribuição. A compilação anterior usou API BepInEx pre.2 com Interop 1.5.3; isso não autoriza montar/instalar um loader misturado.

Defaults work/interop e work/tools atendem o ambiente local anterior. Um clone novo não os contém: fornecer caminhos explicitamente ou reconstruir em work conforme tools/README.md. Ausência gera erro.

~~~powershell
./scripts/build.ps1 -GameReferencePath 'CAMINHO_INTEROP' -BepInExCorePath 'CAMINHO_CORE' -InteropReferencePath 'CAMINHO_RUNTIME'
./scripts/test.ps1 -WithContracts -GameReferencePath 'CAMINHO_INTEROP'
~~~

## Saídas e testes

ClearedHotTrainer.sln contém plugin e testes. scripts/build.ps1 compila ambos em Release; -PublicOnly compila só o console de testes e o mesmo ProtectionPolicy.cs de produção, sem fingir uma DLL de plugin.

Saída completa: build/bin/ClearedHotTrainer/Release/net6.0/ClearedHot.LocalAssist.dll. build/obj e logs são ignorados.

~~~powershell
./scripts/build.ps1 -PublicOnly
./scripts/test.ps1 -NoBuild
./tests/Test-Audit.ps1
./scripts/build.ps1
./scripts/test.ps1 -WithContracts -NoBuild
./scripts/package.ps1 -SkipBuild
~~~

São testes C# de console com assertivas/exit code real, não dotnet test sem descoberta. O pacote exige DLL completa, versão correta e testes de contratos. Recusa sobrescrever pacote existente; release é apenas saída local, sem GitHub Release.

tests/Test-Package.ps1 recebe caminhos explícitos e uma fixture de versão compilada de tests/Fixtures/LoaderFixture. Ela nunca é loader funcional ou dependência de distribuição. Usar uma NOVA pasta em work como destino; nunca a instalação Steam.

## Troubleshooting

- SDK ausente: verificar dotnet --info e usar SDK Microsoft compatível.
- Referências ausentes: definir os parâmetros; não enviar DLLs do jogo ao GitHub.
- Metadata 39 recusado: investigar loader/parser; build 692 é incompatível. Não remover barreiras para forçar instalação.
- Erro de detour/tipos: guardar log local e investigar a combinação exata. Redigir logs antes de compartilhar.
- Pacote existente: arquivar explicitamente ou adotar outra versão.
- Script bloqueado: seguir política local ou fazer cópia manual após autorização/backup. Não desativar Defender nem impor administrador.
- CI verde: significa apenas o escopo público, sem compilação da integração ou sucesso no jogo.

.NET 6 está fora de suporte; .NET 8 chega ao fim de suporte em novembro de 2026. Planejar atualização separadamente, sem quebrar a API do loader. Fontes: https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core e https://devblogs.microsoft.com/dotnet/dotnet-8-9-end-of-support/.

## Referências atuais — 31/10/2026

Os defaults agora usam work/interop-791/generated (cópia dos wrappers gerados pelo loader na instalação real) e work/tools/bepinex-791/BepInEx/core para BepInEx/Harmony/Runtime. Esses caminhos continuam locais e ignorados. Um clone novo precisa fornecer as referências explicitamente. O uso do indexador components[i] é necessário para o List<T> gerado pelo loader; a chamada explícita get_Item do wrapper antigo é recusada pelo compilador.
