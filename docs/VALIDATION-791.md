# Validação do loader e instalação — 31/10/2026

## Confirmado por execução real

- Download oficial build 791; 227 arquivos adicionados com manifesto externo e hashes conferidos, sem sobreposição de originais.
- Download e extração automática das bibliotecas Unity 6000.3.23 pelo próprio loader.
- Geração de 214 DLLs de interop; marcador assembly-hash.txt criado.
- Inicialização do chainloader, abertura do menu e voo de teste no Apache AH-64.
- Compilação com cópia dos wrappers gerados pelo loader e bibliotecas do pacote 791. Uma incompatibilidade de fonte identificada e corrigida: components.get_Item(i) deve ser escrito components[i]. O build falhou antes da alteração (CS0571) e passou após ela, sem avisos/erros.
- 16 verificações de política e 19 de contratos/artefato passaram com esses wrappers.
- Simulação e instalação do plugin pelo instalador; backup adicional de GameAssembly e metadata verificado antes da cópia.
- Plugin carregado, 17 patches registrados, GodMode/InfiniteAmmo/NoOverheat true.
- Aquisição de helicóptero, OnDisable e reaquisição no voo de teste; interceptações de disponibilidade e consumo de munição registradas.
- SHA256 do build, payload e DLL instalada: 6D78C56C3AEDB10CBD498FDC7FE95C05420D23265D494D05F57CBA7401DEF468.
- Os nove arquivos originais preservados, hashes revalidados depois de instalar e iniciar.

## Ainda em teste

O usuário confirmou os três recursos na sessão descrita abaixo. Permanece pendente a cobertura de todas as armas/mísseis, componentes, reinício de missão e progressão roteirizada. Não interpretar registros de patches como comprovação desses comportamentos.

## Aviso observado

Il2CppInterop registrou: Class::Init signatures have been exhausted, using a substitute! A inicialização prosseguiu e os 17 patches foram registrados. O alcance desse fallback exige observação durante o gameplay; não foi suprimido nem contornado.

## Registros locais

- logs/loader-791-install-state.json: manifesto do loader e hashes dos arquivos adicionados.
- logs/loader-only-runtime.log: primeira sessão sem plugin.
- logs/trainer-runtime-791.log: recorte do log com diagnósticos do trainer.
- logs/build-plugin-791-indexer-before.log: falha que demonstrou a incompatibilidade do acessor.
- logs/build-plugin.log e logs/tests.log: compilação e contratos após correção.
- release/ClearedHotTrainer-0.1.0-alpha/install-state.json: registro da DLL instalada e caminho de seu backup adicional.

Os registros brutos e os binários derivados do jogo permanecem ignorados pelo Git. Os arquivos de código e documentação podem ser enviados ao repositório privado; registros brutos e binários locais não fazem parte desse envio.

## Resultado de gameplay informado pelo usuário

Em 31/10/2026, após controlar o voo de teste e receber a pergunta específica sobre munição de mísseis, ausência de superaquecimento e vida intacta ao receber dano, o usuário respondeu: “Sim ! funcionou tudo !”. Os três recursos foram, portanto, confirmados pelo usuário nessa sessão.

Essa confirmação é relato do operador, não medição automatizada de dano/calor nem comprovação de todas as armas e missões. Modelo de cada arma, duração de disparo e valores de dano não foram individualizados. Permanecem pendentes cobertura ampla, componentes, reinício/troca de missão e progressão roteirizada. Os logs confirmam os patches, alvo e interceptação de munição; não registram individualmente os três efeitos observados pelo usuário.
