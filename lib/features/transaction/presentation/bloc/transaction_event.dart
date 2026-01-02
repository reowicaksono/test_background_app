part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class SendTransactionEvent extends TransactionEvent {
  const SendTransactionEvent({
    required this.fcmToken,
    required this.transaction,
  });

  final String fcmToken;
  final TransactionEntities transaction;

  @override
  List<Object> get props => [fcmToken, transaction];
}
