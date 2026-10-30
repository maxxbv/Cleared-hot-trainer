# Metadata e pontos de integração

A instalação analisada informou Unity 6000.3.23f1, PE AMD64 e metadata com assinatura 0xFAB11BAF/versão 39. Cpp2IL pre-release.21 localizou registros e mapeou 211858 definições. Il2CppInterop CLI 1.5.3 gerou wrappers offline sem unstripping/cache de xrefs. Dados completos não são redistribuídos.

Assembly relevante: Cfinger.Runtime; os tipos não foram presumidos em Assembly-CSharp.

| Área | Membros reais |
|---|---|
| Jogador | PlayerHeloController.heloController; Awake, OnEnable, Update, SwapHeloControl, OnDisable |
| Propriedade | HeloController.player, mainHealth, healthMaster, heloDamageManager |
| Dano | HealthController.TakeDamage(float), TakeDamage(DamageData), InternalTakeDamage(DamageData), Kill, SetHealthInternal(float,bool) |
| Destruição | HeloController.OnHeloDestroyed; HeloRotorDeathController.HandleRotorDeath |
| Inventário | HeloInventoryGenericAmmo.ConsumeItem/GetNumItems; HeloInventoryManager.GetNumOfType |
| Calor | HeloDeviceMinigun.ProcessOverheatStatus(float), FixedUpdate, overheatTimer, overheated |
| Mísseis | HeloDeviceMissileLauncher.HasAmmo/LaunchMissileAt |

A rotina nativa de consumo genérico decrementa a contagem. Minigun/mísseis consultam GetNumOfType, que consulta virtualmente a entrada do inventário. Entrada ausente retorna zero antes de GetNumItems: o patch adicional limita esse caso a armas equipadas e ligadas ao jogador.

A rotina térmica consulta overheatDisabled e manipula timer/estado. O plugin atual limpa timer/estado nos caminhos interceptados.

Contratos verificam assinaturas/arquitetura, não inlining nativo, detours, propriedade em runtime ou cobertura de missões.
