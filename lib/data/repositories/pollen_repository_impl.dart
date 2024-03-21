import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pollen_tracker/data/mappers/pollen_dto_to_pollen_entity_mapper.dart';
import 'package:pollen_tracker/data/models/local/pollen_entity.dart';
import 'package:pollen_tracker/data/models/remote/ambee_dto.dart';
import 'package:pollen_tracker/domain/repositories/pollen_repository.dart';

class PollenRepositoryImpl implements PollenRepository {

  static const _apiHeader = 'x-api-key';

  final _url = 'latest/pollen/by-lat-lng';
  final Map<String, dynamic> _headers = {
    _apiHeader: const String.fromEnvironment('AMBEE_KEY'),
    'Content-type': 'application/json',
  };

  @override
  Future<List<PollenEntity>> getPollenEntities(double lat, double lng) async {
    if (_apiHeader.isEmpty) {
      throw AssertionError('AMBEE_KEY is not set');
    }

    final Map<String, dynamic> queries = {'lat': lat, 'lng': lng};
    final dio = GetIt.I<Dio>();
    final options = Options(headers: _headers);

    final rs = await dio.get(
      _url,
      options: options,
      queryParameters: queries,
    );

    PollenDtoToPollenEntityMappper mapper =
        GetIt.I<PollenDtoToPollenEntityMappper>();

    return mapper.map(AmbeeDto.fromJson(rs.data));
  }
}
