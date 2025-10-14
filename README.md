# lista_infinita

Propósito
---------
`lista_infinita` é um exemplo pequeno e direto em Flutter que demonstra uma lista infinita com paginação e pull-to-refresh. O projeto gera dados localmente (fábrica de modelos) para simular uma API paginada e focar nas preocupações de UI e lógica de paginação (evitar duplicações, controlar concorrência).

Arquitetura (resumo)
--------------------
- UI (View): `lib/presentation/view.dart` — contém `RefreshIndicator` e `ListView`.
- Controller: `lib/presentation/controller.dart` — gerencia estado, paginação, proteção contra chamadas concorrentes (single-flight) e exposições de `items`/`isLoading`.
- Repository / DataSource: `lib/data/repository.dart` e `lib/data/datasource.dart` — contrato claro: `read(page, limit)` retorna apenas os novos itens da página; `clear()` reseta o armazenamento.
- Model: `lib/domain/models/produto.dart` — fábrica de produtos para simular itens paginados.

Decisões rápidas
-----------------
- `read` retorna somente a página solicitada (evita confusão quando quem consome faz `addAll`).
- Controller usa um bloqueio single-flight para evitar fetches concorrentes que causariam duplicação.
- `ListTile` usa `ValueKey(produto.id)` para estabilidade visual.

Diagrama
--------
![Arquitetura otimizada](assets/diagrams/google_architecture_optimized.png)

Como rodar
----------
No PowerShell:

```powershell
cd "A:\Cursos\flutter\lista_infinita"
flutter pub get
flutter run
```

Testes
------
```powershell
flutter test
```

