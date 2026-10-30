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
