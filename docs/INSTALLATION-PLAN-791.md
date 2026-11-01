# Plano de instalação experimental — build 791

Data: 31/10/2026. Plano aprovado e executado pelo usuário nesta data; resultados em VALIDATION-791.md. O texto abaixo preserva a sequência proposta antes da execução.

## Pré-condições verificadas

Pacote oficial BepInEx Unity IL2CPP win-x64 791 íntegro para leitura, parser metadata 39 e inicialização Cpp2IL offline aprovados. Plugin recompilado com referências do pacote. Backup canônico em backups/ClearedHot-backup-20261029-205754: nove arquivos, incluindo os oito arquivos originais da raiz e metadata, todos revalidados. Não é backup completo do conteúdo do jogo nem dos saves.

## Sequência após aprovação

1. Confirmar jogo fechado, revalidar backup e inventariar a instalação. Interromper em qualquer conflito de caminho existente; nunca sobrescrever originais.
2. Adicionar somente os arquivos do loader do ZIP oficial na raiz C:\Program Files (x86)\Steam\steamapps\common\ClearedHot: BepInEx/core, dotnet, winhttp.dll, doorstop_config.ini e .doorstop_version. Guardar manifesto de cada arquivo adicionado e hash fora do jogo; changelog não precisa ser instalado.
3. Iniciar o jogo uma vez apenas com loader e conferir LogOutput.log, download das bibliotecas Unity e geração de interop. Se houver erro, interromper antes de adicionar o trainer. O primeiro início pode requerer rede para bibliotecas Unity oficiais.
4. Usar os wrappers gerados pelo próprio loader para recompilar e verificar novamente os contratos. Atualizar o pacote local com essa DLL antes de instalar o trainer.
5. Executar a simulação do instalador e então adicionar BepInEx/plugins/ClearedHot.LocalAssist/ClearedHot.LocalAssist.dll. O instalador cria seu próprio backup verificado e registro.
6. Iniciar single-player e testar dano, destruição/componentes, munição de todas as armas e mísseis, calor, inimigos sem proteção, restart/troca de helicóptero e nova missão. Registrar os resultados observados e logs; não declarar sucesso só pelo registro dos patches.

Não modificar GameAssembly.dll ou metadata, alterar Defender, executar como administrador ou instalar evasão de anticheat. Permissão recusada deve interromper a operação para avaliação.

## Remoção

Fechar o jogo e usar o desinstalador do pacote para remover somente a DLL registrada com hash correspondente. Para remover o loader, usar o manifesto da etapa 2 e remover somente arquivos adicionados cujos hashes ainda coincidam; revisar separadamente caches/config gerados e preservar backups e saves. Nenhum original precisa ser restaurado se os hashes permanecerem iguais.

## Limite antes da execução

A compatibilidade offline passou. Carregamento, geração de interop, detours, comportamento e progressão de missões permanecem não validados. A DLL preparada antes da primeira execução ainda usa wrappers da análise anterior.
