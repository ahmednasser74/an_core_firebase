import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  late final FirebaseRemoteConfig _remoteConfig;

  /// Call this during app startup
  Future<void> init({Map<String, Object>? defaultValues}) async {
    _remoteConfig = FirebaseRemoteConfig.instance;

    // Set default values (optional fallback)
    await _remoteConfig.setDefaults(defaultValues ?? {});

    // Fetch & activate the latest config from server
    await _remoteConfig.fetchAndActivate();
  }

  /// Get a String config
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  /// Get a bool config
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  /// Get an int config
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  /// Get a double config
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _remoteConfig.getAll().containsKey(key);
  }
}
