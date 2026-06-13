import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:math_riddles/core/constants/asset_paths.dart';
import 'package:math_riddles/data/models/riddle.dart';
import 'package:math_riddles/data/repositories/riddle_repository.dart';

/// Remote implementation that fetches from a URL with a fallback to local assets.
class RemoteRiddleRepository implements RiddleRepository {
  RemoteRiddleRepository({required this.backendUrl});

  final String backendUrl;

  List<Riddle>? _cache;
  Map<String, Riddle>? _byIdMap;

  @override
  Future<List<Riddle>> loadAll() async {
    if (_cache != null) return _cache!;

    final riddles = <Riddle>[];
    String? jsonString;

    try {
      // 1. Attempt to fetch from remote URL
      final response = await http.get(Uri.parse(backendUrl)).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        jsonString = utf8.decode(response.bodyBytes);
      } else {
        throw Exception('Failed to load remote riddles: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // 2. Fallback to local asset if network request fails or times out
      jsonString = await rootBundle.loadString(AssetPaths.riddlesJson);
    }

    // 3. Parse JSON
    final riddlesList = json.decode(jsonString) as List<dynamic>;
    for (final item in riddlesList) {
      try {
        riddles.add(Riddle.fromJson(item as Map<String, dynamic>));
      } on Exception catch (e) {
        assert(
          () {
            throw FormatException(
              'Failed to parse riddle: $item\nError: $e',
            );
          }(),
          'Riddle parse failure in debug mode',
        );
      }
    }

    _cache = List.unmodifiable(riddles);
    _byIdMap = {for (final r in riddles) r.id: r};

    return _cache!;
  }

  @override
  Future<Riddle?> byId(String id) async {
    if (_byIdMap == null) await loadAll();
    return _byIdMap?[id];
  }
}
