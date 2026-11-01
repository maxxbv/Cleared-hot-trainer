# Cleared Hot Trainer — pacote local alpha

Implementação experimental: os três recursos estão ligados por padrão, sem teclas. Funcionamento dos três recursos confirmado pelo usuário em uma sessão; cobertura de todas as armas/missões pendente. Loader não incluído.

## Antes de instalar

É necessário BepInEx 6 Unity IL2CPP win-x64 compatível com Unity 6000.3.23f1/metadata 39. O build 692 foi testado e recusa esse metadata. O instalador exige preventivamente build 791+/Interop 1.5.3+, mas isso não demonstra compatibilidade real.

A instalação local com build 791 foi aprovada e executada em 31/10/2026. Para outra instalação, verificar backup e compatibilidade antes dos passos de escrita.

Feche o jogo e mantenha este pacote fora da pasta Steam. No pacote extraído:

~~~powershell
./Install.ps1 -WhatIf
# Após autorização: ./Install.ps1
~~~

No repositório, os equivalentes são scripts/install.ps1 e scripts/uninstall.ps1, com -PackagePath opcional.

O instalador confere hashes do jogo e payload; faz backup verificado de GameAssembly.dll e global-metadata.dat em backups, dentro deste pacote e fora do jogo; só depois adiciona:

BepInEx/plugins/ClearedHot.LocalAssist/ClearedHot.LocalAssist.dll

Nenhum original é sobrescrito. Não execute como administrador sem necessidade; se houver recusa de acesso, interrompa e trate a permissão específica. Não desative Defender.

No primeiro carregamento, BepInEx pode gerar caches/interop, config/local.clearedhot.assist.cfg e LogOutput.log. GodMode, InfiniteAmmo e NoOverheat são true por padrão; configurações já existentes são respeitadas.

## Remoção

Com o jogo fechado e usando o mesmo pacote/registro install-state.json:

~~~powershell
./Uninstall.ps1 -WhatIf
# Após autorização de remoção: ./Uninstall.ps1
~~~

A remoção apaga somente a DLL com caminho/hash registrados e sua pasta se vazia. Preserva backups, configuração, originais, loader e outros mods. Arquivo alterado é recusado. Não é preciso restaurar originais porque não foram modificados. Para reinstalar, use nova extração do ZIP.

## Diagnóstico

Patched indica registro, não funcionamento. Player helicopter acquired indica resolução de alvo. Observed player interception indica que o caminho atingiu um patch; não substitui observação de gameplay.

Testar componentes, todas as armas/mísseis, calor, inimigos sem benefícios, restart/respawn/trocas/cutscenes e missões roteirizadas. Não há proteção global de Destroy; bloquear callbacks identificados pode interferir em progressão. Ver PROJECT_STATUS.md e docs/TESTING.md.

Single-player apenas. Nenhum mecanismo de evasão de anticheat.

## Estado instalado — 31/10/2026

Instalação experimental aprovada e executada com BepInEx 791. Loader, geração de interop, carregamento do plugin e registro dos patches confirmados no jogo. A DLL foi recompilada com os wrappers dessa execução. Evidência de efeitos em todas as armas, calor e dano ainda deve ser registrada separadamente; carregar patches não demonstra esses efeitos.

O log do build 791 é BepInEx/LogOutput.log. Para remover a DLL instalada, usar release/ClearedHotTrainer-0.1.0-alpha/Uninstall.ps1 com o jogo fechado, preservando install-state.json e o backup associado. O ZIP é limpo; os backups e registros existem somente na pasta local instalada e não são distribuídos.

No teste single-player de 31/10/2026, o usuário confirmou funcionamento dos três recursos. Nenhuma tecla de ativação é necessária: iniciar o jogo normalmente pelo Steam. Configuração: BepInEx/config/local.clearedhot.assist.cfg, opções GodMode, InfiniteAmmo e NoOverheat true. A confirmação vale para essa sessão; cobertura ampla permanece pendente. Relatório no repositório: docs/VALIDATION-791.md.
