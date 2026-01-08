import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_key.dart';
part 'local_storage_repositories.dart';

class LocalStorageImpl implements LocalStorageRepositories {
  LocalStorageImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  @override
  Future<void> clearFcmToken() {
    return sharedPreferences.remove(LocalStorageKey.fcmToken);
  }

  @override
  Future<String?> getFcmToken() async {
    return sharedPreferences.getString(LocalStorageKey.fcmToken);
  }

  @override
  Future<void> saveFcmToken({required String fcmToken}) {
    return sharedPreferences.setString(LocalStorageKey.fcmToken, fcmToken);
  }
}
