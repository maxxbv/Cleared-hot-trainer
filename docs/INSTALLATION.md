# Cleared Hot Trainer — pacote local alpha

Implementação experimental: os três recursos estão ligados por padrão, sem teclas. Funcionamento em missão ainda não foi validado. Loader não incluído.

## Antes de instalar

É necessário BepInEx 6 Unity IL2CPP win-x64 compatível com Unity 6000.3.23f1/metadata 39. O build 692 foi testado e recusa esse metadata. O instalador exige preventivamente build 791+/Interop 1.5.3+, mas isso não demonstra compatibilidade real.

Nesta etapa de preparação do Git não há autorização de instalação. Não execute os passos com escrita até aprovação separada e confirmação do loader.

Feche o jogo e mantenha este pacote fora da pasta Steam. No pacote extraído:

~~~powershell
./Install.ps1 -WhatIf
# Após autorização: ./Install.ps1
~~~

No repositório, os equivalentes são scripts/install.ps1 e scripts/uninstall.ps1, com -PackagePath opcional.

O instalador confere hashes do jogo e payload; faz backup verificado de GameAssembly.dll e global-metadata.dat em backups, dentro deste pacote e fora do jogo; só depois adiciona:

BepInEx/plugins/ClearedHot.LocalAssist/ClearedHot.LocalAssist.dll

Nenhum original é sobrescrito. Não execute como administrador sem necessidade; se houver recusa de acesso, interrompa e trate a permissão específica. Não desative Defender.

No primeiro carregamento, BepInEx pode gerar caches/interop, config/local.clearedhot.assist.cfg e LogOutput.txt. GodMode, InfiniteAmmo e NoOverheat são true por padrão; configurações já existentes são respeitadas.

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
