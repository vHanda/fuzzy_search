import 'package:test/test.dart';

import 'package:fuzzy_search/src/string_match.dart';

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
        expect(result!.indexes, testData[2] as List<int>);
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

  group('Scoring', () {
    test('Start of string bonus', () {
      var input = [
        'stringfind',
        'findstring',
      ];

      expect(_match(input, 'find'), 'findstring');
    });

    test('Consequtive characters bonus', () {
      var input = [
        'findstring',
        'findstrfing',
      ];

      expect(_match(input, 'string'), 'findstring');
    });
  });
}

String _match(List<String> input, String needle) {
  var scores = <String, int>{};
  for (var str in input) {
    var s = fuzzySearch(str, needle);
    var score = s != null ? s.score : int64MinValue;
    scores[str] = score;
  }

  input.sort(
    (a, b) => scores[a]!.compareTo(scores[b]!),
  );

  return input.last;
}
