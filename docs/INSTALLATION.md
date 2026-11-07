# Instalação — Cleared Hot Trainer 0.1.1-alpha

Atualização para a versão analisada em 07/11/2026: Unity 6000.3.28f1, IL2CPP x64, metadata 39. O instalador e o plugin verificam os hashes exatos de GameAssembly.dll e metadata. Outras atualizações são recusadas até nova análise. Ver UPDATE-20261107.md no repositório.

## Loader e bibliotecas

BepInEx Unity IL2CPP win-x64 build 791 e Il2CppInterop 1.5.3 usados nos testes. O pacote do trainer não inclui loader, bibliotecas Unity ou wrappers do jogo.

O servidor oficial do BepInEx retornou 404 para 6000.3.28.zip. Nesta máquina, o cache exato foi preparado a partir do módulo Windows Mono oficial da Unity 6000.3.28f1, sem executar instalador. O cache fica em BepInEx/unity-libs/6000.3.28.zip. Não substituir por bibliotecas de outra versão nem desativar a geração de interop. Origem, hashes e procedimento documentados em docs/UPDATE-20261107.md no repositório.

## Instalação e atualização

Feche o jogo. Mantenha o pacote extraído fora da instalação Steam. Faça backup verificado antes de alterar a instalação. Para atualizar a 0.1.0, use primeiro o Uninstall.ps1 do pacote antigo com seu install-state.json; preserve os backups e o registro antigo. Não restaure binários antigos sobre o jogo atualizado.

No pacote novo:

~~~powershell
./Install.ps1 -WhatIf
./Install.ps1
~~~

O instalador verifica o jogo, dependências e SHA256 do payload; faz backup verificado de GameAssembly.dll e global-metadata.dat fora do jogo e adiciona somente BepInEx/plugins/ClearedHot.LocalAssist/ClearedHot.LocalAssist.dll. Recusa sobrescrever DLL existente. Não execute como administrador sem necessidade nem altere Defender.

Inicie pelo Steam. GodMode, InfiniteAmmo e NoOverheat são true por padrão, sem teclas; a configuração existente é preservada em BepInEx/config/local.clearedhot.assist.cfg. Diagnóstico em BepInEx/LogOutput.log. Conferir versão 0.1.1-alpha, hashes aceitos, 17 patches, opções true e aquisição do jogador. Registro de patches não comprova todos os efeitos em missão.

## Remoção

Com o jogo fechado, no mesmo pacote que instalou a versão:

~~~powershell
./Uninstall.ps1 -WhatIf
./Uninstall.ps1
~~~

Remove somente a DLL cujo caminho/hash coincide com o registro. Preserva loader, cache Unity, configurações, saves, outros mods e backups. DLL alterada é recusada. Guarde o pacote instalado com install-state.json e seus backups. Nenhum original precisa ser restaurado porque o trainer não os modifica.

## Testes e limites

Os três recursos foram confirmados pelo usuário na 0.1.0 em uma sessão anterior. Isso não valida o jogo atualizado: testar novamente dano/componentes/destruição, munição de cada arma/míssil, calor contínuo, restart, troca de helicóptero e novas missões. Inimigos não devem receber os benefícios. Destruição roteirizada e progressão exigem observação. Não há hook global de Destroy. Uso single-player apenas; nenhuma evasão de anticheat.
