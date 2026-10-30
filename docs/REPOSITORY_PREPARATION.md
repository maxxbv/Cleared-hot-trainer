# Resultado da preparação Git

Registro histórico do estado anterior à autorização de publicação. Para o estado atual do repositório privado e do CI, consultar PROJECT_STATUS.md e docs/CI.md.

## Estrutura

~~~text
.github/       workflows e templates
src/           plugin C# canônico
tests/         testes públicos, contratos e fixtures
analysis/      relatórios resumidos sem dumps/binários
tools/         documentação e fontes das ferramentas
docs/          procedimentos e auditoria
scripts/       build, teste, auditoria, pacote, instalação e remoção
build/         intermediários locais ignorados
release/       pacotes locais ignorados
logs/          resultados locais ignorados
backups/       backup canônico verificado, ignorado
work/outputs/  acervo anterior privado, ignorado
~~~

Configuração de raiz: solução, global.json, Directory.Build.props, NuGet.config, .gitignore, .gitattributes e .editorconfig. Documentação principal: README, ARCHITECTURE, DEVELOPMENT, PROJECT_STATUS, CHANGELOG e CONTRIBUTING.

O código anterior foi copiado para a estrutura canônica e preservado no acervo ignorado. A versão passou a 0.1.0-alpha; nome da DLL e identificador foram mantidos. AGENTS.md local foi atualizado e permanece ignorado.

## Evidência local

- Build Release completo do plugin net6.0/x64 e testes net8.0: zero erros/avisos.
- 16 verificações de política e 19 contratos/artefato passaram.
- 14 testes de arquivos do pacote passaram somente em fixture.
- Testes da auditoria: recusa de caminho proprietário, padrão de credencial, segredo staged com cópia de trabalho limpa e aceitação após restaging.
- Falha de auditoria staged/working-tree foi reproduzida antes da correção e eliminada por leitura direta dos blobs.
- 21 exemplos de caminhos proibidos confirmados por git check-ignore.
- actionlint validou o workflow.
- Uma cópia limpa sem referências proprietárias compilou/testou o escopo público; build completo recusou referências ausentes e não gerou plugin falso.
- O workflow remoto não foi executado. Não há validação de gameplay.

## Git e segurança

Repositório local inicializado em main, sem histórico anterior, commit, remoto, push, tag ou release. Arquivos públicos preparados no índice para revisão. A lista completa e o resultado mecanizado ficam em logs, fora do Git.

Índice sem DLLs, executáveis, metadata, wrappers, dumps, saves, arquivos compactados, backups, logs pessoais ou padrões de alta confiança de credenciais. Auditoria não é detector universal e não alega varredura de todos os blobs de históricos futuros; não há commits nesta preparação.

Git instalado; GitHub CLI ausente no PATH. Instruções oficiais e comandos estão em docs/GITHUB.md. Primeiro commit sugerido: chore: initialize cleared hot trainer project.

## Pendências

Compatibilidade do loader metadata 39, teste real em missão, atualização futura de SDK/runtime e escolha de licença pública. O inventário de dependências registra hashes e URLs de releases/fontes, mas ainda não detalha todos os nomes exatos dos assets de download; isso foi registrado como melhoria documental menor.

Não instalar o plugin ou publicar remotamente nesta etapa. A futura criação do repositório deve preferir privado e depende de autorização explícita.
