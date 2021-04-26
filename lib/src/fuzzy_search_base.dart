import 'package:tuple/tuple.dart';

class Score {
  int value = 0;
  var log = <Tuple2<int, String>>[];

  void add(int amount, {required String reason}) {
    value += amount;
    log.add(Tuple2<int, String>(amount, reason));
  }
}

Tuple2<Score, List<int>>? fuzzySearch(String base, String needle) {
  if (needle.isEmpty) {
    return Tuple2<Score, List<int>>(Score(), []);
  }

  var score = Score();
  var indexes = <int>[];
  var remainder = String.fromCharCodes(needle.codeUnits);
  for (var i = 0; i < base.codeUnits.length; i++) {
    var char = base.codeUnits[i];
    if (char == remainder.codeUnits.first) {
      remainder = String.fromCharCodes(remainder.codeUnits, 1);
      indexes.add(i);
      score.add(1, reason: 'Match ${String.fromCharCode(char)}');
      if (remainder.isEmpty) {
        return Tuple2<Score, List<int>>(score, indexes);
      }
    } else {
      score.add(-1, reason: 'Skip ${String.fromCharCode(char)}');
    }
  }

  return null;
}
