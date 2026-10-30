# Auditoria inicial

29/10/2026, antes das alterações:

- Cerca de 2,87 GiB/47.669 arquivos locais em work e outputs.
- 5.155 arquivos binários/archives por extensão, incluindo ferramentas, referências, cópias de testes e backups.
- Fontes em work/project/src; testes e scripts já existentes.
- Nenhum .git ou histórico: nada foi reescrito.
- Git 2.54.0.windows.1 disponível; gh ausente. Autor Git configurado, sem expor identidade neste relatório.
- SDK portátil 8.0.427; plugin previamente compilado net6.0/AMD64.
- Busca de padrões de alta confiança nas fontes próprias e pacote textual anterior sem credenciais encontradas. Não foi auditoria universal de binários/dependências.

## Exclusões

GameAssembly.dll, metadata, saves, backups, dumps integrais, wrappers, SDK, executáveis, arquivos compactados e logs permanecem locais/ignorados. analysis recebe somente relatórios resumidos novos.

AGENTS.md contém orientação local/caminhos pessoais e está ignorado. A documentação pública não copia nomes de usuário dos registros históricos.

.gitignore e audit.ps1 protegem o índice contra diretórios/extensões proibidos, binários/arquivos grandes e padrões de credenciais/perfis pessoais. Valores sensíveis não são impressos.

A lista do índice é revisada antes do primeiro commit. Não há commits/blobs históricos nesta preparação. Para futuros históricos, o script informa seu escopo sem alegar análise completa.

Nenhum remoto, push, tag, release ou instalação é executado. Relatório mecanizado final e lista do índice ficam em logs, apenas localmente.

A auditoria padrão lê os blobs exatos do índice Git, não o conteúdo possivelmente diferente da cópia de trabalho. -Paths seleciona explicitamente a cópia de trabalho apenas para inspeção direcionada/fixtures. Um teste de regressão comprova que um segredo staged é recusado mesmo após limpar o arquivo sem restaging.
