import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/generate_etoken.dart';
import '../../domain/usecases/register_etoken.dart';
import 'etoken_event.dart';
import 'etoken_state.dart';

class ETokenBloc extends Bloc<ETokenEvent, ETokenState> {
  final RegisterEToken registerEToken;
  final GenerateEToken generateEToken;

  ETokenBloc({required this.registerEToken, required this.generateEToken})
    : super(ETokenInitial()) {
    on<RegisterETokenEvent>(_onRegisterEToken);
    on<GenerateETokenEvent>(_onGenerateEToken);
  }

  Future<void> _onRegisterEToken(
    RegisterETokenEvent event,
    Emitter<ETokenState> emit,
  ) async {
    emit(ETokenLoading());
    final failureOrEntity = await registerEToken(
      RegisterETokenParams(
        password: event.password,
        deviceName: event.deviceName,
        deviceId: event.deviceId,
        deviceType: event.deviceType,
        accountName: event.accountName,
      ),
    );

    failureOrEntity.fold(
      (failure) => emit(ETokenError(message: _mapFailureToMessage(failure))),
      (entity) => emit(ETokenRegisterSuccess(secretKey: entity.secretKey)),
    );
  }

  Future<void> _onGenerateEToken(
    GenerateETokenEvent event,
    Emitter<ETokenState> emit,
  ) async {
    emit(ETokenLoading());
    final failureOrCode = await generateEToken(
      GenerateETokenParams(password: event.password),
    );

    failureOrCode.fold(
      (failure) => emit(ETokenError(message: _mapFailureToMessage(failure))),
      (code) => emit(ETokenGenerateSuccess(tokenCode: code)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
