import 'package:pollen_tracker/domain/models/config_entity.dart';

abstract interface class ConfigRepository {
  Future<bool> set(ConfigEntity config);
  // Think twice before using this method!!
  // Are you sure you want get config and not subscribe to it?
  // Always consider ConfigSubject first!
  Future<ConfigEntity> get();
}
