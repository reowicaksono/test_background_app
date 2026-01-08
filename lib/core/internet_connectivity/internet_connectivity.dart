import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityRepository extends ChangeNotifier {
  ConnectivityRepository() {
    _checkConnection();
    listenToNetworkChange();
  }

  bool resctricted = false;
  void restrictSnackbar() {
    resctricted = true;
  }

  ConnectivityResult connectionType = ConnectivityResult.none;
  bool isConnected = true;
  StreamSubscription? subscription;

  List<ConnectivityResult> _normalizeResults(dynamic results) {
    if (results is List<ConnectivityResult>) {
      return results;
    }
    if (results is ConnectivityResult) {
      return [results];
    }
    return const [];
  }

  void _checkConnection() async {
    final results = _normalizeResults(await Connectivity().checkConnectivity());
    isConnected =
        !results.contains(ConnectivityResult.none) && results.isNotEmpty;
    connectionType = results.isNotEmpty
        ? results.first
        : ConnectivityResult.none;
  }

  void listenToNetworkChange() {
    subscription = Connectivity().onConnectivityChanged.listen((results) {
      final normalizedResults = _normalizeResults(results);
      final hasConnection =
          !normalizedResults.contains(ConnectivityResult.none) &&
          normalizedResults.isNotEmpty;

      if (hasConnection) {
        resctricted = false;
      }
      isConnected = hasConnection;
      connectionType = normalizedResults.isNotEmpty
          ? normalizedResults.first
          : ConnectivityResult.none;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
