part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionSuccess extends TransactionState {
  const TransactionSuccess({required this.transaction});

  final TransactionEntities transaction;

  @override
  List<Object> get props => [transaction];
}

final class TransactionFailure extends TransactionState {
  const TransactionFailure({required this.failure});

  final String failure;

  @override
  List<Object> get props => [failure];
}
