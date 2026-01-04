import 'package:equatable/equatable.dart';
import 'package:test_background_service/features/transaction/domain/enum/transaction_enum.dart';

class TransactionEntities extends Equatable {
  final String id;
  final String amount;
  final TransactionStatus status;

  TransactionEntities({
    required this.id,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => [id, amount, status];
}

