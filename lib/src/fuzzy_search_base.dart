import 'package:tuple/tuple.dart';

class _Matrix {
  List<List<int?>> value = [[]];

  // FIXME: Store this as a Int16List

  _Matrix({required int rows, required int cols}) {
    value = List<List<int?>>.generate(
      rows,
      (_) => List<int?>.filled(cols, null),
    );
  }

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

Tuple2<int, List<int>>? fuzzySearch(String base, String needle) {
  // print('_fuzzySearchMatrix $base $needle');
  if (base.length < needle.length) {
    return null;
  }
  if (needle.isEmpty) {
    return Tuple2<int, List<int>>(0, []);
  }

  var m = _Matrix(rows: needle.length, cols: base.length);
  var mIndexes = _Matrix(rows: needle.length, cols: base.length);

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
        var maxPreviousX = -1;
        for (var prevX = 0; prevX <= x - 1; prevX++) {
          var s = m.value[y - 1][prevX];
          if (s == null) {
            continue;
          }

          var gapPenalty = (x - prevX) - 1;
          var finalScore = s - gapPenalty;
          if (finalScore >= maxPrevious) {
            maxPrevious = finalScore;
            maxPreviousX = prevX;
          }
          // print('y $y x $x prevX $prevX gapPenalty: $gapPenalty');
        }
        // print('y $y x $x maxPrev $maxPrevious');
        score += maxPrevious;
        mIndexes.value[y - 1][x] = maxPreviousX;
      }
      m.value[y][x] = score;
    }

    if (!didMatch) {
      return null;
    }
  }

  // m.debugPrint(base);
  // mIndexes.debugPrint(base);

  var lastRow = m.value[needle.length - 1];
  var maxScore = int64MinValue;
  var maxScoreIndex = -1;
  for (var i = lastRow.length - 1; i >= needle.length; i--) {
    final val = lastRow[i];
    if (val != null && val > maxScore) {
      maxScore = val;
      maxScoreIndex = i;
    }
  }

  var indexes = <int>[maxScoreIndex];
  for (var y = needle.length - 2; y > 0; y--) {
    var i = mIndexes.value[y][maxScoreIndex];
    assert(i != null);

    maxScoreIndex = i!;
    indexes.insert(0, maxScoreIndex);
  }
  // print(indexes);

  return Tuple2<int, List<int>>(maxScore, indexes);
}

const int int64MinValue = -9223372036854775808;
const int int64MaxValue = 9223372036854775807;

const int int16MinValue = -32768;
const int int16MaxValue = 32767;
