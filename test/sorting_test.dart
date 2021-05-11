/*

Production Release
don't change size of Avatar in Menu
Integrate latest version of Sentry - flutter web
-> rele

source/test/regression/graph.swift
source/string.swift
str/testing.swift
-> string

*/

import 'package:test/test.dart';

import 'package:fuzzy_search/fuzzy_search.dart';

class MatchTest {
  List<String> data;
  String input;
  String output;

  MatchTest(this.data, this.input, this.output);
}

var data = [
  MatchTest(['colony', 'old man'], 'ol', 'old man'),
  MatchTest(['cman', 'right man'], 'man', 'right man'),
  MatchTest([
    'Production Release',
    'don\'t change size of Avatar in Menu',
    'Integrate latest version of Sentry - flutter web',
    'Set a large account min balance on projects that need it',
  ], 'rele', 'Production Release'),
  MatchTest([
    'source/test/regression/graph.swift',
    'source/string.swift',
    'str/testing.swift',
  ], 'string', 'source/string.swift'),
];

void main() {
  for (var t in data) {
    test('test ${t.input} -> ${t.output}', () {
      var matches = topMatches(t.data, t.input);
      expect(matches.first, t.output);
      expect(matches.length, 1);
    });
  }
}

List<String> topMatches(List<String> data, String input) {
  var db = FuzzySearch<String>(data, mappingFn: (a) => a);
  var results = db.match(input);
  results.sort((a, b) => a.score.compareTo(b.score));

  var matches = <String>[];
  var score = results.last.score;
  for (var result in results.reversed) {
    if (result.score == score) {
      matches.add(result.obj);
    }
    //print('${result.obj} -> ${result.score}');
  }

  return matches;
}
