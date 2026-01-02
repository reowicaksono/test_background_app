import 'package:test_background_service/features/transaction/data/models/transaction_model.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';

class TransactionMapper {
  static TransactionModel toModel(TransactionEntities entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      status: entity.status,
    );
  }

  static TransactionEntities toEntity(TransactionModel data) {
    return TransactionEntities(
      id: data.id,
      amount: data.amount,
      status: data.status,
    );
  }
}
