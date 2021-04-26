import 'package:fuzzy_search/fuzzy_search.dart';
import 'package:test/test.dart';

void main() {
  test('Simple Matching Tests', () {
    var inputs = [
      'source/string.swift',
      'source/test/regression/graph.swift',
    ];

    for (var i in inputs) {
      expect(fuzzySearch(i, 'string'), isNotNull);
    }
  });

  test('Simple Failing Tests', () {
    var inputs = [
      'graph.swift',
      'source/strinf.swift',
      'small',
    ];

    for (var i in inputs) {
      expect(fuzzySearch(i, 'string'), isNull);
    }
  });
}
