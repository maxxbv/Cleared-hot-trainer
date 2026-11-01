# Compatibilidade do loader

O pacote BepInEx 6.0.0-be.692, commit 851521cc126e4f9d841d2d9bfe857558f0395939, foi testado offline.

- Il2CppInterop 1.4.6-ci.426.
- Cpp2IL/LibCpp2IL 2022.1.0-development.972, commit ba1003aa6e2d406b212e08818974fc83fe846fd7.
- Metadata real: 39.

Sua própria biblioteca recusou o arquivo:

~~~text
Unsupported metadata version found! We support 23-29, got 39
~~~

O teste não iniciou o loader ou jogo. Comprova que o pacote 692, como distribuído, não gera o interop necessário. Alterar o limite do instalador não resolve o parser.

Builds atuais do servidor oficial não puderam ser obtidos nas tentativas anteriores. Build 791+/Interop 1.5.3+ é apenas requisito preventivo do instalador, não combinação validada.

API BepInEx pre.2 foi usada somente como referência de compilação com wrappers reais e Interop 1.5.3; isso não valida instalar esse conjunto como loader.

Fontes: https://github.com/BepInEx/BepInEx e https://github.com/SamboyCoding/Cpp2IL. Binários e logs completos permanecem locais/ignorados.

## Validação offline do build 791 — 31/10/2026

O download oficial foi concluído e o ZIP foi lido integralmente (233 entradas, 34.336.890 bytes). SHA256: BB1C510909B69522733791F3A0817A487379A52DA6468A492F1C9C19B3EC6F9A.

- BepInEx 6.0.0-be.791+b782da4ac54e1072d2857f4a2f77c80c3ef08005.
- Il2CppInterop.Runtime 1.5.3+dbda1cb353b0f4253345dc45136d170b9e50a5a0.
- Cpp2IL/LibCpp2IL development.1452+558ddd9.
- Parser do próprio pacote leu metadata 39: 28.317 tipos, 211.858 métodos e 186 imagens.
- InitializeLibCpp2Il passou com GameAssembly.dll e metadata reais, UnityVersion 6000.3.23f1 e registro x86_64 equivalente ao loader.
- Plugin recompilado com Core, Harmony e Runtime do pacote 791: zero avisos/erros. Dezesseis testes de política e dezenove de contratos/artefato passaram.
- Nove arquivos do backup e originais conferidos por SHA256.

Esses testes não executaram o loader, a geração completa de interop nem detours no processo do jogo. Os wrappers usados na compilação são os existentes da análise anterior. Não comprovam funcionamento em missão. Nenhum arquivo do jogo foi alterado.

Evidência local ignorada: logs/loader-791-full-probe.log, logs/build-plugin.log, logs/tests.log, logs/backup-revalidation-791.json. Harness local: work/loader-validation-791.

## Sessão real do build 791

Em 31/10/2026, loader 791 instalado após aprovação: geração de interop concluída, menu/voo de teste abertos e plugin carregado com os 17 patches. O teste de compilação contra os wrappers gerados expôs e confirmou a correção do acessor da lista. Ver docs/VALIDATION-791.md para evidências e limites; efeitos de gameplay ainda em observação pelo usuário. O log atual é BepInEx/LogOutput.log.
