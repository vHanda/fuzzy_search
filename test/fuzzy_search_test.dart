import 'package:fuzzy_search/fuzzy_search.dart';
import 'package:test/test.dart';

void main() {
  test('Simple Matching Tests', () {
    var inputs = [
      'source/test/regression/graph.swift',
      'source/string.swift',
    ];

    for (var i in inputs) {
      expect(fuzzySearch(i, 'string'), isTrue);
    }
  });

  test('Simple Failing Tests', () {
    var inputs = [
      'graph.swift',
      'source/strinf.swift',
    ];

    for (var i in inputs) {
      expect(fuzzySearch(i, 'string'), isFalse);
    }
  });
}
