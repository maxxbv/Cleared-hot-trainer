# Ferramentas

Este diretório contém documentação/inventário. Executáveis, SDKs e downloads ficam em work/tools, fora do Git.

Fontes oficiais: https://dotnet.microsoft.com/download, https://github.com/BepInEx/BepInEx, https://builds.bepinex.dev/projects/bepinex_be, https://github.com/SamboyCoding/Cpp2IL/releases/tag/2022.1.0-pre-release.21, https://github.com/BepInEx/Il2CppInterop/releases/tag/v1.5.3, https://git-scm.com/download/win, https://cli.github.com/ e https://github.com/rhysd/actionlint.

dependencies.json registra os downloads previamente usados, sem incorporar as dependências. Respeitar suas licenças separadamente.

## Referências privadas

Com ferramentas oficiais, sempre com saída fora da instalação Steam:

~~~powershell
& 'CAMINHO_CPP2IL' --game-path 'CAMINHO_JOGO' --output-as dummydll --output-to 'CAMINHO_WORK/dummy'
dotnet 'CAMINHO_INTEROP_CLI/Il2CppInterop.CLI.dll' generate --input 'CAMINHO_WORK/dummy' --output 'CAMINHO_WORK/interop' --game-assembly 'CAMINHO_JOGO/GameAssembly.dll' --no-xref-cache
~~~

Manter saídas em work. Não substituir o interop do loader pelo gerado apenas para compilação. Não baixar binários de espelhos desconhecidos, exigir administrador para análise ou alterar GameAssembly.dll/metadata.
