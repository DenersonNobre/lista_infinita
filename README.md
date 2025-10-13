## Propósito do projeto

`lista_infinita` é um pequeno projeto/laboratório em Flutter que demonstra a implementação de uma lista infinita (infinite scroll) com paginação e pull-to-refresh. O código gera itens de exemplo (Produtos) por uma fábrica local para simular carregamento paginado e explorar padrões de arquitetura simples para apps Flutter.
## Propósito do projeto

`lista_infinita` é um pequeno projeto/laboratório em Flutter que demonstra a implementação de uma lista infinita (infinite scroll) com paginação e pull-to-refresh. O código gera itens de exemplo (Produtos) por uma fábrica local para simular carregamento paginado e explorar padrões de arquitetura simples para apps Flutter.

Este repositório serve como base de código para desenvolvedores que querem:
- estudar padrões de separação de responsabilidades (UI / Controller / Repository),
- entender problemas comuns em paginação (duplicação de itens, concorrência),
- ver estratégias simples de teste unitário para lógica de domínio.

## Público-alvo

O projeto é indicado para desenvolvedores Flutter iniciantes a intermediários que desejam um exemplo prático de:
- Implementação de lista infinita com paginação e refresh;
- Separação entre camada de apresentação (widgets), controladora (controller) e repositório (fonte dos dados);
- Boas práticas simples: contratos claros entre repositório e controller, proteção contra chamadas concorrentes e testes automatizados.

## Arquitetura aplicada

O projeto adota uma arquitetura leve, baseada em camadas e responsabilidades claras (inspirada em MVVM/Controller-lite):

- UI / Widgets:
	- `lib/app/app_widget.dart` — ponto de entrada do MaterialApp.
	- `lib/home/home_page.dart` — widget de tela que contém `RefreshIndicator` e `ListView.builder`, observando o `HomeController` via `AnimatedBuilder`.

- Controller / State:
	- `lib/home/home_controller.dart` — gerencia estado da lista, paginação, controle de loading, `ScrollController` e lógica de fetch.
	- Expõe `items`, `isLoading` (ValueNotifier), `isRefreshing` e `scrollController`.

- Repositório / Fonte de Dados:
	- `lib/home/home_repository.dart` — simula fonte paginada; possui método `read({page, limit})` que gera itens via fábrica e mantém `_items` localmente.
	- Fornece `clear()` para resetar o armazenamento.

- Model:
	- `lib/models/produto.dart` — definição do `Produto` e `factory(int index)` que produz itens de exemplo.

Fluxo de dados (resumido):

1. `HomePage` chama `HomeController.fetchData(refresh: true)` quando o usuário puxa para atualizar (pull-to-refresh).
2. `HomeController` coordena o reset (quando necessário), inicia um load e chama `HomeRepository.read(page, limit)` para obter os itens da próxima página.
3. `HomeRepository.read` gera `newItems` para a página solicitada, adiciona-os ao seu armazenamento interno `_items` e retorna apenas `newItems`.
4. `HomeController` decide se substitui a lista (`items = newItems`) no caso de refresh, ou concatena (`items.addAll(newItems)`) no caso de paginação.
5. A UI observa o controller e rebuilda a lista.

Decisões de design importantes:

- `read` retorna apenas os novos itens (não a lista completa): isso deixa o contrato explícito e evita duplicações acidentais quando consumidores fizerem `addAll` na lista local.
- Single-flight (`_ongoingFetch` no controller): evita chamadas concorrentes que poderiam gerar duplicação quando duas requisições são feitas simultaneamente.
- Uso de `ValueKey(produto.id)` nos `ListTile`: ajuda o Flutter a reconciliar widgets corretamente, dando estabilidade visual na UI.

## Como rodar localmente

Pré-requisitos: Flutter SDK (compatível com o SDK no `pubspec.yaml`).

No PowerShell (Windows), dentro da pasta do projeto:

```powershell
cd "A:\Cursos\flutter\lista_infinita"
flutter pub get
flutter run
```

Para rodar os testes unitários criados:

```powershell
cd "A:\Cursos\flutter\lista_infinita"
flutter test
```

## Testes

O projeto inclui testes unitários em `test/` que validam:
- `HomeRepository.read` (retorno dos novos itens e atualização do armazenamento interno);
- `HomeController.fetchData` (comportamento de paginação, refresh e chamadas concorrentes).

Os testes foram executados localmente e passam.

## Próximos passos e sugestões de melhoria

- Adicionar tratamento de erros nas operações de fetch (ex.: retry/backoff).
- Implementar caching de páginas (se necessário) e invalidação seletiva.
- Criar testes de widget/integration para validar o pull-to-refresh e a experiência de scroll em um ambiente mais próximo ao real.
- Expor um pequeno README de arquitetura (diagrama) e documentação de API se você planeja usar essa base como template para outros projetos.

---

Se quiser, eu posso:
- adicionar diagrama simples da arquitetura no README;
- incluir testes de widget/integration;
- documentar contratos públicos dos métodos (por exemplo, comportamento de `HomeRepository.read` em casos de erro).

## Diagrama de arquitetura (Mermaid)

Abaixo há uma versão Mermaid adaptada do diagrama do time do Google que você anexou. Ela mostra as camadas UI e Data, com o ViewModel ligando a View ao Repository/Service.

```mermaid
flowchart LR
	subgraph UI_layer [UI layer]
		direction LR
		View["View\n(home_page.dart)"]
		ViewModel["ViewModel\n(home_controller.dart)"]
		View -- observa --> ViewModel
	end

	subgraph Data_layer [Data layer]
		direction LR
		ModelBox[(Model)]
		subgraph Model_comp [Model]
			direction LR
			Repository["Repository\n(home_repository.dart)"]
			Service["Service\n(remote/local data source)\n(implement later)"]
			Repository <--> Service
		end
	end

	ViewModel -- solicita/recebe --> Repository
	Repository -- fornece modelos --> ViewModel
```

	### Diagrama oficial (imagem)

	Diagrama oficial do time do Google (colocado na área de transferência e salvo em `assets/diagrams/google_architecture.png`).

	![Google architecture diagram](assets/diagrams/google_architecture_optimized.png)

	Legenda (mapeamento dos blocos para arquivos do projeto):

	- View (UI): `lib/home/home_page.dart` — contém o `RefreshIndicator` e a `ListView`.
	- ViewModel: `lib/home/home_controller.dart` — gerencia estado, paginação e lógica de fetch.
	- Repository: `lib/home/home_repository.dart` — provê `read` e `clear` e mantém armazenamento local `_items`.
	- Service (Data Source): não implementado separadamente neste laboratório; aqui você poderia adicionar `lib/data/remote_data_source.dart` e `lib/data/local_data_source.dart`.

## Diagrama de sequência (fluxo de fetch)

```mermaid
sequenceDiagram
	participant U as UI (HomePage)
	participant C as Controller (HomeController)
	participant R as Repo (HomeRepository)

	U->>C: fetchData(refresh: true)
	C->>R: clear() [se refresh]
	C->>R: read(page, limit)
	R-->>C: newItems
	C-->>U: items (replace or add)
```

## Contratos públicos (resumo)

- `HomeRepository.read({int page = 1, int limit = 20}) -> Future<List<T>>`
	- Gera e adiciona os itens dessa página ao armazenamento interno `_items`.
	- Retorna apenas os `newItems` gerados nesta chamada (contrato claro para os consumidores).
	- Não lança (neste laboratório) — em um sistema real deve expor erros via exceção ou objeto de resultado.

- `HomeRepository.clear()`
	- Limpa o armazenamento interno `_items`.

- `HomeController.fetchData({bool refresh = false}) -> Future<void>`
	- Single-flight: múltiplas chamadas concorrentes aguardam a mesma operação em andamento.
	- Se `refresh == true`: limpa repositório e lista local, reseta `_currentPage` e carrega a primeira página (substitui `items`).
	- Se `refresh == false`: carrega a próxima página e concatena os `newItems` a `items`.

## Título

# lista_infinita

Demonstração de lista infinita consumindo api fake.
