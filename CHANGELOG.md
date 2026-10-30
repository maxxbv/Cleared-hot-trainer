# Changelog

Seguindo [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) e [Semantic Versioning](https://semver.org/).

## [Unreleased]

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
