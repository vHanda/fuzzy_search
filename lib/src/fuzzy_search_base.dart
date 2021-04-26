import 'dart:math';

import 'package:tuple/tuple.dart';

class Score {
  int value = 0;
  var log = <Tuple2<int, String>>[];

  void add(int amount, {required String reason}) {
    value += amount;
    log.add(Tuple2<int, String>(amount, reason));
  }
}

/*
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
*/

class _Matrix {
  List<List<int?>> value = [[]];

  void debugPrint(String base) {
    var str = base + '\n';

    for (var y = 0; y < value.length; y++) {
      for (var x = 0; x < value[y].length; x++) {
        var val = value[y][x];
        if (val != null) {
          str += val.toString();
        } else {
          str += '.';
        }
      }
      str += '\n';
    }

    print(str);
  }
}

Tuple2<int, _Matrix>? fuzzySearch(String base, String needle) {
  // print('_fuzzySearchMatrix $base $needle');
  if (base.length < needle.length) {
    return null;
  }

  var m = _Matrix();
  m.value = List<List<int?>>.generate(
    needle.length,
    (_) => List<int?>.filled(base.length, null),
  );

  if (needle.isEmpty) {
    return Tuple2<int, _Matrix>(0, m);
  }

  for (var y = 0; y < needle.length; y++) {
    var needleChar = needle.codeUnitAt(y);
    var didMatch = false;
    var prevMatchIndex = 0;
    if (y == 0) {
      prevMatchIndex = -1;
    } else {
      prevMatchIndex = m.value[y - 1].indexWhere((v) => v != null);
    }

    for (var x = prevMatchIndex + 1; x < m.value[y].length; x++) {
      var char = base.codeUnitAt(x);
      if (needleChar != char) {
        continue;
      }

      didMatch = true;
      var score = 1;
      if (y > 0) {
        var maxPrevious = int64MinValue;
        for (var prevX = 0; prevX <= x - 1; prevX++) {
          var s = m.value[y - 1][prevX];
          if (s == null) {
            continue;
          }

          var gapPenalty = (x - prevX) - 1;
          // print('y $y x $x prevX $prevX gapPenalty: $gapPenalty');
          maxPrevious = max(s - gapPenalty, maxPrevious);
        }
        // print('y $y x $x maxPrev $maxPrevious');
        score += maxPrevious;
      }
      m.value[y][x] = score;
    }

    if (!didMatch) {
      return null;
    }
  }

  // m.debugPrint(base);

  var lastRow = m.value[needle.length - 1];
  var maxScore = int64MinValue;
  for (var i = lastRow.length - 1; i >= needle.length; i--) {
    final val = lastRow[i];
    if (val != null && val > maxScore) {
      maxScore = val;
    }
  }

  return Tuple2<int, _Matrix>(maxScore, m);
}

const int int64MinValue = -9223372036854775808;
const int int64MaxValue = 9223372036854775807;
