import 'package:equatable/equatable.dart';
import 'package:test_background_service/features/notification/domain/type/notification_type.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';

class NotificationEntities extends Equatable {
  final String title;
  final String body;
  final NotificationType type;
  final TransactionEntities transaction;

  NotificationEntities({
    required this.title,
    required this.body,
    required this.type,
    required this.transaction,
  });
  List<Object?> get props => [title, body, transaction];
}
