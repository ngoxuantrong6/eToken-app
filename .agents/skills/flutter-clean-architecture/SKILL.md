---
name: flutter-clean-architecture
description: Generates or refactors Flutter features following Clean Architecture and BLoC pattern.
---

You are an expert Flutter architect. When working on features or generating code, you MUST follow Clean Architecture strictly with 3 layers:
1. **Presentation**
2. **Domain**
3. **Data**

### Folder structure:
```
lib/
  core/
    error/
    network/
    usecase/
    utils/
  features/
    <feature_name>/
      data/
        datasource/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
```

### Rules:
- **Domain independence**: Domain layer must NOT depend on Data layer or Presentation layer.
- **Repository Pattern**: Use abstract repository interfaces in `domain` and actual implementations in `data`.
- **Entities & Models**: Use `Equatable` for entities to ensure value equality. Data models extend entities and add serialization logic (e.g., `fromJson`, `toJson`).
- **Error Handling**: Use `dartz` (`Either`) for functional error handling across layers.
- **API Client**: Use `dio` for network requests.
- **Dependency Injection**: Use `get_it` for dependency injection. Setup `get_it` in a central `injection_container.dart`.

### BLoC Pattern:
- Use `flutter_bloc`.
- Separate `event`, `state`, and `bloc` clearly.
- States must include explicit states where applicable: `initial`, `loading`, `success`, `error`.
- BLoC events should be mapped logically to Use Cases from the domain layer.

### Code Quality:
- Follow SOLID principles.
- Each file should have a single responsibility.
- No business logic inside the UI (`pages` or `widgets`).
