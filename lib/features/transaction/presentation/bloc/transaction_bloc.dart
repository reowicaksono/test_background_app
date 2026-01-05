import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_background_service/app/logger/app_logger.dart';
import 'package:test_background_service/app/logger/enum_logger.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';
import 'package:test_background_service/features/transaction/domain/repositories/transaction_repositories.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this.repositories) : super(TransactionInitial()) {
    on<SendTransactionEvent>(_onSendTransaction);
  }

  final TransactionRepositories repositories;

  Future<void> _onSendTransaction(
    SendTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final result = await repositories.sendNotification(
      fcmToken: event.fcmToken,
      transaction: event.transaction,
    );

    result.fold(
      (failure) {
        AppLogger.log(
          "Failed to send notification ${failure.message}",
          level: LogLevel.error,
          error: failure,
          tag: "Transaction Bloc",
        );
        emit(TransactionFailure(failure: failure.message));
      },
      (transaction) {
        AppLogger.log(
          "Successfully sent notification",
          level: LogLevel.info,
          data: transaction,
          tag: "Transaction Bloc",
        );
        emit(TransactionSuccess(transaction: transaction));
      },
    );
  }
}
