# Segurança

Este projeto é um mod local experimental, single-player, sem vínculo com os desenvolvedores de Cleared Hot.

## Reportar uma vulnerabilidade

Use a opção privada **Report a vulnerability** na aba Security do repositório:
https://github.com/maxxbv/Cleared-hot-trainer/security/advisories/new

Não publique credenciais, dumps, arquivos do jogo, saves ou logs completos em issues. Informe versão do trainer, comportamento observado e passos mínimos para reprodução, removendo dados pessoais. Se o formulário privado estiver indisponível, não coloque detalhes sensíveis em uma issue pública.

## Escopo e contribuições

Apenas código próprio e documentação podem ser versionados. DLLs do jogo, metadata, wrappers gerados, bibliotecas Unity, loaders, backups, saves, credenciais e logs permanecem fora do Git, inclusive por Git LFS. Referências necessárias ao build completo são obtidas localmente de fontes oficiais.

A configuração do CI usa permissões de leitura e actions fixadas por commit. O CI público compila testes e a política compartilhada; não compila a integração proprietária nem comprova gameplay. Nenhuma instalação ou publicação de pacote é automática.

O trainer recusa builds do jogo cujos hashes não correspondem à versão analisada. Antes de instalar, fazer backup verificado; nunca substituir binários originais nem restaurar backups de uma versão antiga sobre um jogo atualizado. Não incluir multiplayer, evasão de anticheat, alterações no Defender ou execução administrativa desnecessária.

A versão 0.1.1-alpha foi testada pelo usuário em uma sessão. Não há promessa de cobertura de todas as armas, missões ou futuras atualizações. Consulte PROJECT_STATUS.md e docs/UPDATE-20261107.md.
