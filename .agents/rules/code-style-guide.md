---
trigger: always_on
---

You are a senior Flutter architect.

Generate a complete Flutter project using Clean Architecture and BLoC pattern similar to the structure of "Flutter-Bloc-CleanArchitecture" repository.

### Requirements:

1. Architecture:

* Follow Clean Architecture strictly with 3 layers:

  * Presentation
  * Domain
  * Data

2. Folder structure:
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

3. Rules:

* Domain layer must NOT depend on Data layer
* Use abstract repository in domain and implementation in data
* Use Equatable for entities
* Use Dartz (Either) for error handling
* Use Dio for API client
* Use get_it for dependency injection

4. BLoC:

* Use flutter_bloc
* Separate event, state, bloc clearly
* States must include: initial, loading, success, error

5. Sample feature:
   Create a sample "eToken" feature including:

* Register eToken usecase (input: 6-digit eToken password, deviceName, deviceId, deviceType, accountName → call API to get secretKey)
* Generate eToken usecase (input: eToken password → verify and generate 6-digit code)
* eToken entity (secretKey, phoneNumber, deviceId)
* eToken repository (abstract + implementation)
* eToken remote datasource (API to register and get secretKey)
* eToken local datasource (store secretKey and eToken password in local storage)
* eToken bloc (event + state + bloc for register and generate flows)
* eToken UI:

  * Register screen (input eToken password, call API, save secretKey)
  * Generate screen (input password, generate 6-digit eToken code based on secretKey, phoneNumber, deviceId, refresh every 30 seconds)

6. Dependency Injection:

* Setup get_it in a central injection_container.dart

7. Code quality:

* Follow SOLID principles
* Each file should have a single responsibility
* No business logic inside UI

8. Output:

* Generate full folder structure
* Provide key files implementation
* Explain how layers interact

Do NOT simplify architecture. Keep it production-ready.