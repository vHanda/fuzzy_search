import 'package:test/test.dart';

import 'package:fuzzy_search/fuzzy_search.dart';

void main() {
  group('Simple Matching Tests', () {
    var inputs = [
      [
        'string',
        'source/string.swift',
        [7, 8, 9, 10, 11, 12]
      ],
      [
        'string',
        'source/test/regression/graph.swift',
        [9, 10, 15, 19, 21, 23]
      ],
      [
        'find',
        'findstring',
        [0, 1, 2, 3],
      ],
    ];

    for (var testData in inputs) {
      var needle = testData[0] as String;
      var hay = testData[1] as String;
      test('$hay - $needle', () {
        var result = fuzzySearch(hay, needle);
        expect(result, isNotNull);
        expect(result!.item2, testData[2] as List<int>);
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
