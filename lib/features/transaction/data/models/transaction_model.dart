import 'package:test_background_service/features/transaction/domain/enum/transaction_enum.dart';

class TransactionModel {
  final String id;
  final String amount;
  final TransactionStatus status;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      status: _parseStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount, 'status': _statusToString(status)};
  }

  static TransactionStatus _parseStatus(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'pending':
          return TransactionStatus.pending;
        case 'success':
          return TransactionStatus.success;
        case 'failed':
          return TransactionStatus.failed;
        default:
          return TransactionStatus.pending;
      }
    }
    return TransactionStatus.pending;
  }

  static String _statusToString(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'pending';
      case TransactionStatus.success:
        return 'success';
      case TransactionStatus.failed:
        return 'failed';
    }
  }
}
