# Status do projeto

29/10/2026 — desenvolvimento 0.1.0-alpha.

## Concluído

- Identificação estática: Unity 6000.3.23f1, IL2CPP AMD64, metadata 39.
- Membros reais de dano, inventário e calor identificados em Cfinger.Runtime.
- Implementação experimental dos três recursos e ativação padrão restrita ao jogador.
- Compilação local completa e testes de lógica/contratos.
- Backup externo e testes de operações de instalação/remoção em pastas isoladas.
- Estrutura Git, documentação, scripts e workflow de verificações públicas.

## Pendente

- Obter e comprovar compatibilidade de loader/geração de interop/detours no jogo.
- Validar dano, componentes, todas as armas/mísseis, calor, respawn, trocas e novas missões.
- Verificar progressão de missões dependentes de destruição roteirizada.
- Instalar gh, escolher destino e obter autorização explícita antes de criar remoto/push.
- Escolher licença pública antes de eventual distribuição pública.
- Planejar atualização de SDK/runtime alinhada à compatibilidade BepInEx.

## Problemas e limites

O parser do build 692 recusa metadata 39: aceita 23–29. O servidor dos builds atuais não respondeu nas tentativas anteriores. O limite conservador do instalador build 791+ não demonstra compatibilidade.

A DLL completa depende de wrappers proprietários locais. CI hospedado não os recebe, não compila essa integração e não valida gameplay. Não há stubs artificiais para exibir sucesso.

Nenhum recurso foi declarado funcional em missão. O jogo permanece sem mod nesta etapa. Nenhum remoto, push, tag ou release foi criado. Ver docs/TESTING.md; resultados locais e auditoria final ficam em logs.
