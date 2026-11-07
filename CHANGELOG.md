# Changelog

Seguindo [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) e [Semantic Versioning](https://semver.org/).

## [0.1.1-alpha] — 2026-11-07

- Atualiza os hashes aceitos para os binários analisados após a atualização do jogo.
- Recompila com interop gerado para Unity 6000.3.28f1; mantém a verificação dos métodos reais.
- Documenta correção do erro 404 de bibliotecas Unity usando DLLs exatas extraídas do módulo oficial.
- Preserva a configuração e o backup anterior durante a remoção da 0.1.0 e instalação da 0.1.1.

## [Histórico da preparação 0.1.0-alpha]

### Added

- Estrutura de repositório, documentação de arquitetura/desenvolvimento/status e templates GitHub.
- Workflow Windows de verificações públicas com escopo explícito.
- Scripts de build, testes, auditoria, pacote e wrappers de instalação/remoção.
- Exclusões de dados proprietários, ferramentas, backups, credenciais e logs.

### Changed

- Código canônico em src/ClearedHotTrainer e tests; material anterior preservado localmente.
- Versão 0.1.0-alpha, mantendo nome da DLL e identificador.
- Saídas em build, release e logs; backups locais em backups.

### Known limitations

- Implementação existente compila localmente, mas não foi validada no jogo.
- Build 692 do loader rejeita metadata 39.
- Nenhuma tag ou release antes da validação real.
