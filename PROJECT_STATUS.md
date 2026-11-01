# Status do projeto

31/10/2026 — 0.1.0-alpha instalada com BepInEx 791; usuário confirmou os três recursos no teste. Cobertura ampla pendente. Ver docs/VALIDATION-791.md.

## Registro inicial de 29/10/2026 — concluído

- Identificação estática: Unity 6000.3.23f1, IL2CPP AMD64, metadata 39.
- Membros reais de dano, inventário e calor identificados em Cfinger.Runtime.
- Implementação experimental dos três recursos e ativação padrão restrita ao jogador.
- Compilação local completa e testes de lógica/contratos.
- Backup externo e testes de operações de instalação/remoção em pastas isoladas.
- Estrutura Git, documentação, scripts e workflow de verificações públicas.
- Repositório privado publicado com autorização: https://github.com/maxxbv/Cleared-hot-trainer; primeiro workflow público concluído com sucesso.

## Pendências registradas em 29/10/2026

- Obter e comprovar compatibilidade de loader/geração de interop/detours no jogo.
- Validar dano, componentes, todas as armas/mísseis, calor, respawn, trocas e novas missões.
- Verificar progressão de missões dependentes de destruição roteirizada.
- Escolher licença pública antes de eventual distribuição pública.
- Planejar atualização de SDK/runtime alinhada à compatibilidade BepInEx.

## Histórico de problemas em 29/10/2026

O parser do build 692 recusa metadata 39: aceita 23–29. O servidor dos builds atuais não respondeu nas tentativas anteriores. O limite conservador do instalador build 791+ não demonstra compatibilidade.

A DLL completa depende de wrappers proprietários locais. CI hospedado não os recebe, não compila essa integração e não valida gameplay. Não há stubs artificiais para exibir sucesso.

Nenhum recurso foi declarado funcional em missão. O jogo permanece sem mod. A branch main foi enviada ao repositório privado com autorização explícita; nenhuma tag ou GitHub Release foi criada. O GitHub CLI continua opcional: publicação e autenticação foram realizadas com a integração e o Git Credential Manager. Ver docs/TESTING.md; resultados locais e auditoria ficam em logs.

## Atualização — 31/10/2026

Build 791 oficial baixado. Parser e inicialização Cpp2IL offline passaram com os binários reais e Unity 6000.3.23f1. Plugin recompilado com as bibliotecas do pacote 791 sem avisos/erros; 16 testes de política e 19 contratos/artefato passaram. Backup de nove arquivos revalidado contra originais.

O bloqueio anterior de download/parser foi superado. Permanecem pendentes geração completa de interop, carregamento/detours e testes em missão. Instalação continua aguardando aprovação do plano docs/INSTALLATION-PLAN-791.md.

## Instalação autorizada — 31/10/2026

Após aprovação explícita, o loader 791 e o plugin foram instalados sem sobrescrever originais. O loader baixou as bibliotecas Unity 6000.3.23, gerou 214 DLLs de interop e assembly-hash.txt, chegou ao menu e ao voo de teste. O plugin foi recompilado com esses wrappers; corrigiu-se a chamada de List<T>.get_Item para o indexador C#. Compilação aprovada sem avisos/erros; 16 testes de política e 19 contratos/artefato aprovados com os novos wrappers.

O log confirma carregamento do plugin, registro dos 17 patches, três opções true e aquisição/reaquisição do helicóptero no voo de teste. Isso valida carregamento e identificação de alvo, mas ainda não demonstra todos os efeitos de gameplay. Há aviso do Il2CppInterop: Class::Init signatures have been exhausted, using a substitute!; não houve erro de carregamento dos patches nessa execução.

Log desta versão: BepInEx/LogOutput.log (não .txt). Manifesto externo do loader: logs/loader-791-install-state.json. Registro e backup do instalador: release/ClearedHotTrainer-0.1.0-alpha/install-state.json e backups dentro desse pacote. Não arquivar/mover esse pacote instalado sem preservar seu registro e backup. A remoção da DLL usa seu Uninstall.ps1; não remove o loader.

## Resultado do teste do usuário — 31/10/2026

Usuário confirmou que God Mode, munição de mísseis e ausência de superaquecimento funcionaram durante seu teste. Carregamento e aquisição do jogador também foram confirmados nos logs. A validação de gameplay é relato do usuário nesta sessão; não implica cobertura de todas as armas/helicópteros/missões. Ver docs/VALIDATION-791.md. Trainer instalado, com ativação automática e três opções true.
