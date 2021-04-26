import 'package:test/test.dart';

import 'package:fuzzy_search/fuzzy_search.dart';

void main() {
  group('Simple Matching Tests', () {
    var inputs = [
      ['string', 'source/string.swift'],
      ['string', 'source/test/regression/graph.swift'],
    ];

    for (var testData in inputs) {
      var needle = testData[0];
      var hay = testData[1];
      test('$hay - $needle', () {
        expect(fuzzySearch(hay, needle), isNotNull);
      });
    }
  });

  group('Simple Failing Tests', () {
    var inputs = [
      ['string', 'graph.swift'],
      ['string', 'source/strinf.swift'],
      ['string', 'small'],
    ];

    for (var testData in inputs) {
      var needle = testData[0];
      var hay = testData[1];
      test('$hay - $needle', () {
        expect(fuzzySearch(hay, needle), isNull);
      });
    }
  });
}
