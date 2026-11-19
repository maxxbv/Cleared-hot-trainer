# Cleared Hot Trainer

Plugin experimental single-player para Cleared Hot, Windows x64, Unity IL2CPP, BepInEx 6 e HarmonyX. Projeto independente e não oficial, sem vínculo com os desenvolvedores do jogo. Não inclui multiplayer ou evasão de anticheat.

**0.1.1-alpha: atualização para Unity 6000.3.28f1 (07/11/2026). Validação desta atualização em docs/UPDATE-20261107.md.**

## Funcionalidades

| Recurso | Estado do código | Teste no jogo |
|---|---|---|
| God Mode automático | Intercepta dano, reduções de saúde e destruição identificada, somente do jogador | Pendente |
| Infinite Ammo automático | Inventário genérico de munição e disponibilidade de minigun/mísseis equipados | Pendente |
| No Overheat automático | Classe real HeloDeviceMinigun | Pendente |
| Ativação sem teclas/menus | Três opções true por padrão; configurações existentes respeitadas | Pendente |

Compilação e testes estáticos não comprovam detours nativos ou gameplay. Veja [PROJECT_STATUS.md](PROJECT_STATUS.md).

## Requisitos e build

Windows 11 x64, PowerShell 7, Git e SDK .NET 8.0.427 (global.json). Plugin net6.0; testes net8.0. .NET 6 está fora de suporte: atualizar o runtime exige verificar a compatibilidade do loader.

Build completo requer wrappers interop locais desta versão do jogo e referências públicas BepInEx/Il2CppInterop. Não estão no repositório. Para executar, é necessário um loader compatível com Unity 6000.3.28f1/metadata 39; as bibliotecas exatas e os resultados estão documentados em [UPDATE-20261107.md](docs/UPDATE-20261107.md).

~~~powershell
# Compila testes e o mesmo ProtectionPolicy.cs usado em produção; não compila o plugin
./scripts/build.ps1 -PublicOnly
./scripts/test.ps1 -NoBuild

# Compilação completa, usando referências locais existentes
./scripts/build.ps1
./scripts/test.ps1 -WithContracts -NoBuild

# Pacote alpha local; exige DLL completa e testes de contratos
./scripts/package.ps1 -SkipBuild
~~~

Para outras pastas, usar -GameReferencePath, -BepInExCorePath e -InteropReferencePath em build.ps1/package.ps1. Os defaults work/interop-20261107/generated e work/tools/bepinex-791/BepInEx/core usam o ambiente analisado; um clone novo não contém referências. Veja [DEVELOPMENT.md](DEVELOPMENT.md).

A DLL mantém o nome ClearedHot.LocalAssist.dll e o identificador local.clearedhot.assist para compatibilidade.

## Organização

src/ClearedHotTrainer contém o código canônico; tests contém os testes; analysis guarda relatórios resumidos; tools/docs documentam dependências e procedimentos; scripts automatiza o desenvolvimento; .github contém CI e templates.

build, release, logs e backups são locais/ignorados. work e outputs preservam o material anterior, ferramentas e evidências privadas, fora do Git.

## Instalação e remoção

Nenhuma instalação é feita pelo build, testes públicos, pacote ou CI. O jogo permanece somente leitura nesta etapa.

Após futura autorização específica e validação do loader, fechar o jogo e conservar o pacote extraído fora da instalação Steam:

~~~powershell
./scripts/install.ps1 -WhatIf
./scripts/uninstall.ps1 -WhatIf
~~~

No pacote extraído, usar Install.ps1/Uninstall.ps1. Executar sem -WhatIf somente após autorização. O instalador faz backup verificado de GameAssembly.dll e global-metadata.dat antes de adicionar somente a DLL do plugin; não sobrescreve um plugin existente.

A remoção usa caminho fixo e hash registrado, preservando originais, backup, configuração, loader e outros mods. Conservar install-state.json. Para reinstalar após remoção, usar nova extração.

O loader não é incluído. O requisito conservador build 791+/Interop 1.5.3+ não comprova compatibilidade. O build 692 fornecido anteriormente foi comprovadamente recusado pelo parser de metadata.

## CI e limitações

[build.yml](.github/workflows/build.yml) usa windows-latest, restaura/compila realmente os testes com o código de política compartilhado e executa verificações públicas.

**O CI hospedado não compila o plugin completo**, pois não recebe DLLs proprietárias. Não há stubs para fingir sucesso, upload de wrappers, tags ou releases automáticos. Upload manual opcional inclui apenas testes públicos e relatório de auditoria.

A versão do jogo é fixa por hashes; atualizações são recusadas. Saúde de componentes, cutscenes, respawn, transições e objetivos dependentes de destruição precisam ser testados. Destroy global não é bloqueado indiscriminadamente.

A API BepInEx pre.2 foi usada somente como referência de compilação, acompanhada de Interop 1.5.3 e wrappers reais. Não é uma recomendação de loader misturado. O código próprio e a documentação do projeto usam a [licença MIT](LICENSE); direitos do jogo e licenças das ferramentas permanecem com seus titulares.

Detalhes: [ARCHITECTURE.md](ARCHITECTURE.md), [docs/TESTING.md](docs/TESTING.md), [docs/GITHUB.md](docs/GITHUB.md).

## Publicação e segurança

O código e a documentação são públicos. Binários do jogo, metadata, wrappers, bibliotecas Unity, loader, backups, saves e logs permanecem locais e não acompanham o repositório. O build completo exige referências locais da versão analisada. Consulte [SECURITY.md](SECURITY.md) para relatar vulnerabilidades e [docs/PUBLICATION.md](docs/PUBLICATION.md) para o escopo da revisão de publicação. Código próprio e documentação sob [licença MIT](LICENSE).


## Licença e suporte

A licença MIT permite usar, modificar, distribuir e comercializar o código, preservando os avisos de autoria e licença. O software é fornecido no estado em que se encontra, com as cláusulas de ausência de garantia e limitação de responsabilidade do texto original em LICENSE. O projeto não oferece SLA nem compromisso de suporte, manutenção contínua ou compatibilidade com futuras atualizações.

A MIT abrange somente o material original deste projeto. Não licencia Cleared Hot, assets, metadata, wrappers gerados, bibliotecas Unity ou dependências de terceiros. Cada componente externo mantém seus próprios termos. O projeto é independente e não é endossado pelos desenvolvedores do jogo.
