import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pollen_tracker/data/models/local/config_model_isar.dart';

@injectable
class ConfigLocalStorageDatasourceIsar {
  Isar? _isar;

  ConfigLocalStorageDatasourceIsar();
  Future<Isar> _getIsarInstance() async {
    if (_isar != null) {
      return _isar!;
    }
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [ConfigModelIsarSchema],
      directory: dir.path,
    );
  }

  Future<ConfigModelIsar?> fetchConfigModel() async {
    _isar ??= await _getIsarInstance();
    final configModels = await _isar!.configModelIsars.where().findFirst();
    return configModels;
  }

  // TODO Проверить реализацию
  Future<int?> updateModel(ConfigModelIsar newConfig) async {
    late int id;
    _isar ??= await _getIsarInstance();
    //TODO goliksim: Иммутабельность
    final objectToUpdate = await _isar!.configModelIsars.where().findFirst();
    if (objectToUpdate != null) {
      objectToUpdate
        ..lastId = newConfig.lastId
        ..locale = newConfig.locale
        ..isDark = newConfig.isDark;

      await _isar?.writeTxn(() async {
        id = await _isar!.configModelIsars.put(objectToUpdate);
      });
    }
    return id;
  }
}
