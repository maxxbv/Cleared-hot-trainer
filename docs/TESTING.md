# Testes e aceite

| Camada | Evidência | Não comprova |
|---|---|---|
| 16 verificações de política | Identidade nativa, troca de alvo, saúde e disponibilidade numérica de munição | Propriedade real, detours ou gameplay |
| 19 contratos/artefato | 17 assinaturas, recusa de método inexistente, DLL AMD64/nome esperado | Execução de métodos nativos |
| Testes de auditoria | Recusa de caminho proprietário e padrão de credencial | Detecção universal de segredos |
| 14 verificações de pacote | Backup, WhatIf, cópia, recusas, remoção e isolamento | BepInEx real |
| Build completo local | C# compila com referências reais locais | Suporte do runtime |

Os testes C# são console com assertivas/exit code. Erros propagam aos scripts/CI. Não usar dotnet test para obter sucesso sem descoberta.

A fixture BepInEx.Core fornece somente metadados de versão para testes de arquivos. Nunca é loader funcional, dependência de distribuição ou prova de compatibilidade.

## Missão: pendente

Após autorização e loader compatível: confirmar Steam/geração de interop/logs; aquisição do jogador; projéteis/explosões/colisão/rotor/cauda; cada arma/míssil com estoque positivo/zero/ausente; tiro sustentado e calor; inimigos sem benefícios; restart, respawn, trocas e novas missões; progressão roteirizada; remoção e retorno ao comportamento normal.

Nenhum teste em missão foi executado. Não afirmar que os três recursos funcionam antes de observar esse resultado.

Usar pastas NOVAS em work para fixtures. Test-Package.ps1 recebe referências/cópias explicitamente. Nunca usar Steam como destino. Logs completos em logs, ignorados; redigir nomes de usuário, caminhos pessoais e credenciais antes de compartilhar.

Test-StagedAudit.ps1 cria um repositório isolado sem commits, prepara uma credencial simulada no índice e limpa só a cópia de trabalho: a auditoria deve recusar. Após restaging do conteúdo limpo, deve aceitar.
