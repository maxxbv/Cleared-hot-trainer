# Escopo do CI

build.yml usa windows-latest, SDK de global.json e ações fixadas por SHA oficial. Permissão contents: read; credenciais do checkout não persistidas. Não há push, tags, releases ou instalação.

O job restaura e compila em Release o executável de testes real, incluindo o mesmo ProtectionPolicy.cs usado no plugin. Executa assertivas, auditoria e recusa de conteúdo proibido. O escopo -PublicOnly aparece no workflow, job, comando, log e resumo.

O plugin completo depende de wrappers proprietários locais. Eles não são enviados como secrets, artefatos, caches públicos ou conteúdo Git/LFS. O workflow não compila essa integração e não deve ser descrito como prova de compilação do plugin.

Não há stubs de Cfinger nem DLL incompleta com o nome do plugin. Um clone novo que tentar o build completo falhará com instrução sobre referências locais.

Upload opcional apenas manual: diretório do executável público de testes e relatório da auditoria. Não inclui work, outputs, release, backups ou logs gerais.

A execução real no GitHub depende de criação/push autorizados e não aconteceu nesta preparação. actionlint valida sintaxe; execução local dos comandos é evidência distinta.

Fonte: https://docs.github.com/en/actions/tutorials/build-and-test-code/net.
