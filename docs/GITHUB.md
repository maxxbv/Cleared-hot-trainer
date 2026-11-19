# Git e publicação

Endereço canônico: https://github.com/maxxbv/Cleared-hot-trainer. Publicação pública autorizada em 19/11/2026, após revisão dos conteúdos históricos e proteção da autoria. O repositório anterior fica preservado como arquivo privado; ver PUBLICATION.md.

## Antes de enviar alterações

~~~powershell
git status --short --branch
git diff --cached --stat
./scripts/audit.ps1
git diff --cached --check
~~~

O auditor padrão lê os blobs exatos do índice. A publicação de 19/11/2026 também revisou separadamente os quatro snapshots anteriores. O auditor não substitui revisão humana nem é detector completo de segredos históricos. Não incluir binários, referências proprietárias, backups, saves, credenciais ou logs pessoais. Dados sensíveis publicados exigem tratamento imediato; remover só da versão atual não limpa o histórico.

A autoria local deste projeto usa maxxbv e o endereço noreply do GitHub. Não substituir pela identidade pessoal em commits futuros sem considerar a exposição pública. Nunca colocar tokens no remoto, em comandos registrados ou em arquivos versionados; usar a autenticação existente do Git Credential Manager.

O CI mantém o escopo público descrito em CI.md. Não criar tags, Releases, uploads de binários ou instalar o trainer como consequência de um push. Publicação de pacotes exige revisão separada do conteúdo.

Relatos sensíveis devem seguir SECURITY.md na raiz. O material original do projeto usa a licença MIT, em LICENSE; dependências externas mantêm seus próprios termos.
