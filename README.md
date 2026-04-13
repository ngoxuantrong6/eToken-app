# 🔐 eToken App

Ứng dụng xác thực hai yếu tố (2FA) được xây dựng bằng **Flutter**, theo kiến trúc **Clean Architecture** kết hợp với **BLoC Pattern**.

---

## 📋 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Tính năng](#-tính-năng)
- [Kiến trúc](#-kiến-trúc)
- [Cấu trúc thư mục](#-cấu-trúc-thư-mục)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Cài đặt & Chạy](#-cài-đặt--chạy)
- [Luồng hoạt động](#-luồng-hoạt-động)

---

## 🎯 Giới thiệu

**eToken App** là ứng dụng sinh mã OTP (One-Time Password) 6 chữ số dùng để xác thực giao dịch, tương tự Google Authenticator. Ứng dụng hỗ trợ:

- Đăng ký thiết bị và nhận `secretKey` từ server
- Tự động tạo mã OTP 6 chữ số dựa trên `secretKey`, làm mới mỗi 30 giây

---

## ✨ Tính năng

| Tính năng | Mô tả |
|-----------|-------|
| 🔑 Đăng nhập | Xác thực tài khoản người dùng |
| 📱 Đăng ký eToken | Nhập mật khẩu, gửi thông tin thiết bị lên server để lấy `secretKey` |
| 🔢 Sinh mã OTP | Tạo mã 6 chữ số từ `secretKey`, tự làm mới sau mỗi 30 giây |
| 💾 Lưu trữ local | Lưu `secretKey` và thông tin thiết bị vào `SharedPreferences` |
| 🛡️ Xử lý lỗi | Phân biệt rõ lỗi server, lỗi mạng, lỗi nghiệp vụ |

---

## 🏗️ Kiến trúc

Dự án tuân theo **Clean Architecture** với 3 tầng độc lập:

```
┌──────────────────────────────────────┐
│         Presentation Layer           │  ← UI, BLoC
│    (Pages, Widgets, Bloc/Event/State)│
├──────────────────────────────────────┤
│           Domain Layer               │  ← Nghiệp vụ thuần túy
│    (Entities, Repositories, UseCase) │
├──────────────────────────────────────┤
│            Data Layer                │  ← Nguồn dữ liệu
│  (Models, DataSources, Repo Impl)    │
└──────────────────────────────────────┘
```

**Nguyên tắc:**
- **Domain** không phụ thuộc vào **Data** hay **Presentation**
- Giao tiếp giữa các tầng qua **abstract repository**
- Xử lý lỗi bằng `Either<Failure, T>` (thư viện `dartz`)

---

## 📁 Cấu trúc thư mục

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart        # Định nghĩa các Exception
│   │   └── failures.dart          # Định nghĩa các Failure (dùng với Either)
│   ├── network/
│   │   ├── api_service.dart       # Cấu hình Dio HTTP client
│   │   └── network_info.dart      # Kiểm tra kết nối mạng
│   └── usecase/
│       └── usecase.dart           # Abstract UseCase base class
│
├── features/
│   ├── auth/                      # Tính năng xác thực
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── auth_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── auth_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── pages/
│   │           └── login_page.dart
│   │
│   └── etoken/                    # Tính năng eToken chính
│       ├── data/
│       │   ├── datasource/
│       │   │   ├── etoken_local_datasource.dart   # SharedPreferences
│       │   │   └── etoken_remote_datasource.dart  # API calls
│       │   ├── models/
│       │   │   └── etoken_model.dart
│       │   └── repositories/
│       │       └── etoken_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── etoken_entity.dart             # secretKey, phoneNumber, deviceId
│       │   ├── repositories/
│       │   │   └── etoken_repository.dart         # Abstract interface
│       │   └── usecases/
│       │       ├── register_etoken.dart           # Đăng ký → lấy secretKey
│       │       └── generate_etoken.dart           # Sinh mã OTP 6 chữ số
│       └── presentation/
│           ├── bloc/
│           │   ├── etoken_bloc.dart
│           │   ├── etoken_event.dart
│           │   └── etoken_state.dart
│           └── pages/
│               ├── register_page.dart             # Màn hình đăng ký eToken
│               └── generate_page.dart             # Màn hình hiển thị OTP
│
├── injection_container.dart       # Dependency Injection (GetIt)
└── main.dart
```

---

## 🛠️ Công nghệ sử dụng

| Package | Mục đích |
|---------|----------|
| `flutter_bloc` ^9.1.1 | Quản lý state theo BLoC Pattern |
| `dartz` ^0.10.1 | Xử lý lỗi kiểu functional (`Either`) |
| `dio` ^5.9.2 | HTTP client gọi API |
| `get_it` ^9.2.1 | Dependency Injection |
| `equatable` ^2.0.8 | So sánh object trong Entity/State |
| `shared_preferences` ^2.5.3 | Lưu trữ dữ liệu local |
| `device_info_plus` ^12.3.0 | Lấy thông tin thiết bị |
| `package_info_plus` ^8.3.0 | Lấy thông tin ứng dụng |
| `crypto` ^3.0.7 | Hàm hash mã hóa |
| `base32` ^2.2.0 | Encode/decode Base32 (TOTP standard) |

---

## 🚀 Cài đặt & Chạy

### Yêu cầu

- Flutter SDK `^3.8.1`
- Dart SDK `^3.8.1`

### Các bước

```bash
# 1. Clone repository
git clone <repository-url>
cd eToken-app

# 2. Cài đặt dependencies
flutter pub get

# 3. Chạy ứng dụng
flutter run
```

---

## 🔄 Luồng hoạt động

### Đăng ký eToken

```
User nhập mật khẩu eToken (6 chữ số)
        │
        ▼
RegisterEtokenEvent → EtokenBloc
        │
        ▼
RegisterEtokenUseCase (Domain)
        │
        ▼
EtokenRepository (abstract) → EtokenRepositoryImpl (data)
        │                              │
        ▼                              ▼
EtokenRemoteDataSource         EtokenLocalDataSource
  (gọi API → secretKey)         (lưu secretKey vào local)
        │
        ▼
EtokenRegisteredState → UI hiển thị thành công
```

### Sinh mã OTP

```
User nhập mật khẩu eToken
        │
        ▼
GenerateEtokenEvent → EtokenBloc
        │
        ▼
GenerateEtokenUseCase (Domain)
        │
        ▼
Lấy secretKey từ local → Tạo OTP 6 chữ số (TOTP algorithm)
        │
        ▼
EtokenGeneratedState → Hiển thị mã, đếm ngược 30 giây, tự làm mới
```

---

## 📐 Nguyên tắc thiết kế

- ✅ **Single Responsibility**: Mỗi file chỉ có một nhiệm vụ duy nhất
- ✅ **Dependency Inversion**: Tầng trên phụ thuộc vào abstraction, không phụ thuộc vào implementation
- ✅ **No Business Logic in UI**: Tất cả logic nghiệp vụ nằm trong Domain layer
- ✅ **Testable**: Mỗi tầng có thể test độc lập nhờ dependency injection
