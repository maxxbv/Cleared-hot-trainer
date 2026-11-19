# Status do projeto

07/11/2026 — Cleared Hot Trainer 0.1.1-alpha instalado para o jogo atualizado Unity 6000.3.28f1, IL2CPP AMD64, metadata 39.

## Confirmado nesta atualização

- Resolvido o bloqueio do loader: bibliotecas Unity exatas extraídas do módulo oficial, em cache local; geração de 218 DLLs de interop concluída.
- Plugin recompilado com os wrappers atuais; 17 assinaturas reais verificadas; hashes de proteção atualizados para os binários analisados.
- Build sem avisos/erros; 16 testes de política, 19 contratos/artefato e 14 verificações do instalador/desinstalador aprovados.
- 0.1.0 removida pelo registro; 0.1.1 instalada com backup verificado. Configuração preservada, três recursos true e ativação automática.
- Carregamento real no jogo: 17 patches registrados e chainloader concluído. Nove hashes dos originais inalterados após instalar e iniciar.

## Pendente e limites

Usuário confirmou em 07/11/2026 que os três recursos funcionaram no teste da 0.1.1 (dano, mísseis e fogo contínuo). Cobertura ampla ainda pendente: destruição/componentes, todas as armas/mísseis, respawn, trocas e novas missões. A confirmação do usuário de 31/10/2026 se aplica à sessão anterior da 0.1.0. Progressão dependente de destruição roteirizada exige observação. O aviso conhecido do Il2CppInterop sobre fallback de Class::Init permaneceu, sem impedir o carregamento observado.

Relatório: docs/UPDATE-20261107.md. Histórico anterior: docs/VALIDATION-791.md. Logs atuais em BepInEx/LogOutput.log. Registros completos, backups, wrappers e binários permanecem locais/ignorados. Preservar release/ClearedHotTrainer-0.1.1-alpha/install-state.json e backups para remoção segura com Uninstall.ps1. A remoção da DLL preserva loader/cache/configuração.

Publicação pública de código e documentação autorizada em 19/11/2026: https://github.com/maxxbv/Cleared-hot-trainer. Autoria histórica protegida e repositório original preservado como arquivo privado; ver docs/PUBLICATION.md. CI hospedado compila apenas testes/política públicos, sem wrappers proprietários nem validação de gameplay. Plugin net6.0 exige planejamento separado de atualização de runtime; não alterar dependências do loader sem validar compatibilidade.
