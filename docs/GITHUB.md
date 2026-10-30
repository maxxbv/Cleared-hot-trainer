# Git e publicação

Estado atual: https://github.com/maxxbv/Cleared-hot-trainer foi criado como privado e recebeu main após autorização explícita. A publicação usou Git Credential Manager e a integração conectada; gh não é obrigatório para esse fluxo. As instruções abaixo permanecem como referência para operações futuras. Não alterar a visibilidade sem autorização.

Repositório local em main. Não criar remoto/push, tags ou releases automaticamente.

Git disponível; gh não encontrado no PATH. Instalação sugerida, a executar pelo usuário:

~~~powershell
winget install --id GitHub.cli --exact --source winget
gh --version
gh auth login
~~~

Autenticação interativa deve ser realizada pelo usuário. Não salvar tokens em arquivos.

## Antes do primeiro commit

~~~powershell
git status --short --branch
git diff --cached --stat
./scripts/audit.ps1
git diff --cached --check
~~~

Revisar git ls-files e git log --all quando já houver histórico. Não havia repositório/histórico na auditoria inicial. audit.ps1 verifica candidatos e informa commits, mas não é detector completo de segredos históricos. .gitignore não remove dados já versionados; segredos expostos exigem revogação/rotação e tratamento do histórico antes de publicar.

Mensagem sugerida, não executada automaticamente:

~~~powershell
git commit -m "chore: initialize cleared hot trainer project"
~~~

## Somente após autorização explícita

Substituir SEU_USUARIO e preferir privado:

~~~powershell
gh repo create SEU_USUARIO/Cleared-hot-trainer --private --source . --remote origin
git remote -v
git push -u origin main
~~~

São instruções, não ações executadas. Não criar tags/releases antes de validação real.

Referências: https://cli.github.com/manual/gh_repo_create e https://cli.github.com/manual/gh_auth_login.
