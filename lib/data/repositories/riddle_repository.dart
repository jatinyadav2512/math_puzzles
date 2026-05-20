import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:math_riddles/core/constants/asset_paths.dart';
import 'package:math_riddles/data/models/riddle.dart';

/// Abstract interface for loading riddles.
/// UI and providers depend on this abstraction, never on the local impl.
abstract class RiddleRepository {
  /// Load all riddles from all sources.
  Future<List<Riddle>> loadAll();

  /// Look up a single riddle by its stable string id. Returns null if not found.
  Future<Riddle?> byId(String id);
}

/// Local implementation that reads from bundled JSON assets.
class LocalRiddleRepository implements RiddleRepository {
  List<Riddle>? _cache;
  Map<String, Riddle>? _byIdMap;

  @override
  Future<List<Riddle>> loadAll() async {
    if (_cache != null) return _cache!;

    final riddles = <Riddle>[];

    // Load primary riddles JSON.
    final riddlesJson = await rootBundle.loadString(AssetPaths.riddlesJson);
    final riddlesList = json.decode(riddlesJson) as List<dynamic>;
    for (final item in riddlesList) {
      try {
        riddles.add(Riddle.fromJson(item as Map<String, dynamic>));
      } on Exception catch (e) {
        // Debug: throw to surface the offending riddle.
        // Release: skip and log.
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

    // Load optional diagram samples JSON.
    try {
      final diagramsJson = await rootBundle.loadString(
        AssetPaths.riddlesDiagramSamplesJson,
      );
      final diagramsList = json.decode(diagramsJson) as List<dynamic>;
      for (final item in diagramsList) {
        try {
          riddles.add(Riddle.fromJson(item as Map<String, dynamic>));
        } on Exception catch (e) {
          assert(
            () {
              throw FormatException(
                'Failed to parse diagram riddle: $item\nError: $e',
              );
            }(),
            'Diagram riddle parse failure in debug mode',
          );
        }
      }
    } on Exception {
      // Diagram samples file is optional; silently skip if missing.
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
