# Arquitetura

## Componentes

- Plugin.cs: entrada BasePlugin/BepInPlugin, configuração ligada por padrão, hashes SHA256 do jogo, instalação/retirada dos patches e diagnóstico.
- Patches.cs: registro por tipos, nomes e assinaturas exatas. Falha de registro tenta retirar patches; exceção em uso desativa a proteção para evitar continuar inferindo alvos.
- PlayerScope.cs: propriedade por identidade nativa e ligação recíproca entre jogador e helicóptero. O alvo autorizado não é armazenado entre missões.
- ProtectionPolicy.cs: regras puras de identidade, redução de saúde e disponibilidade de munição; mesmo arquivo compilado pelo plugin e pelos testes.
- ContractChecks.cs: leitura estática de assinaturas dos wrappers e cabeçalho da DLL, sem executar código nativo.

## IL2CPP e patches

Wrappers locais fornecem os tipos Cfinger.Runtime, Unity e Il2CppSystem. O plugin net6.0/AMD64 usa BepInEx 6, Il2CppInterop e HarmonyX. Loader/HarmonySupport precisam efetuar os detours em runtime; contratos não comprovam esse funcionamento.

God Mode cobre entrada/aplicação de dano, Kill, reduções de saúde e callbacks identificados de destruição. Cura é permitida; o componente precisa corresponder à saúde principal/master ou à lista do HeloDamageManager, evitando proteger passageiros/inimigos.

Munição cobre ConsumeItem/GetNumItems no inventário genérico do jogador. GetNumOfType trata ausência de estoque/entrada somente para minigun ou lançador equipado e ligado ao helicóptero.

Calor é limpo nos caminhos térmicos/FixedUpdate da minigun do jogador. Não há bloqueio global de Destroy ou mudança permanente dos binários.

## Inicialização automática

Awake, OnEnable, Update e SwapHeloControl acompanham a aquisição do jogador; OnDisable limpa diagnóstico. Cada patch resolve novamente a propriedade. Não há teclas, menus ou incremento repetido de contadores de invulnerabilidade.

As opções GodMode, InfiniteAmmo e NoOverheat são true por padrão; configurações anteriores são respeitadas. A reorganização não alterou alvos de gameplay nem criou uma segunda DLL.

## Build e distribuição

A DLL permanece ClearedHot.LocalAssist.dll, agora 0.1.0-alpha. Build completo é local; CI compila somente os testes e o código real de política. Referências do jogo, dumps, SDK e backups não entram no Git ou no pacote.
