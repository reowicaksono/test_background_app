part of 'local_storage_impl.dart';
abstract class LocalStorageRepositories {
  Future<void> saveFcmToken({required String fcmToken});
  Future<String?> getFcmToken();
  Future<void> clearFcmToken();
}