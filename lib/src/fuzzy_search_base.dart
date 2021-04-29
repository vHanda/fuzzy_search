import 'matrix.dart';

class FuzzySearchResult {
  int score;
  List<int> indexes;

  FuzzySearchResult(this.score, this.indexes);
}

FuzzySearchResult? fuzzySearch(String base, String needle) {
  // print('_fuzzySearchMatrix $base $needle');
  if (base.length < needle.length) {
    return null;
  }
  if (needle.isEmpty) {
    return FuzzySearchResult(0, []);
  }

  var m = Matrix(rows: needle.length, cols: base.length);
  var mIndexes = Matrix(rows: needle.length, cols: base.length);

  var prevMatchIndex = -1;

  for (var y = 0; y < needle.length; y++) {
    var needleChar = needle.codeUnitAt(y);
    int? firstMatchIndex;
    var remainderLength = needle.length - y - 1;

    for (var x = prevMatchIndex + 1; x < base.length - remainderLength; x++) {
      var char = base.codeUnitAt(x);
      if (needleChar != char) {
        continue;
      }

      firstMatchIndex ??= x;

      var score = 1;
      if (y > 0) {
        // Find the max value of the prev row
        var maxPrevious = int64MinValue;
        var maxPreviousX = -1;
        for (var prevX = prevMatchIndex; prevX <= x - 1; prevX++) {
          var s = m.val(y - 1, prevX);
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
        mIndexes.setVal(y - 1, x, maxPreviousX);
      }
      m.setVal(y, x, score);
    }

    if (firstMatchIndex == null) {
      return null;
    } else {
      prevMatchIndex = firstMatchIndex;
    }
  }

  // m.debugPrint(base);
  // mIndexes.debugPrint(base);

  var maxScore = int64MinValue;
  var maxScoreIndex = -1;
  for (var i = base.length - 1; i >= needle.length - 1; i--) {
    final val = m.val(needle.length - 1, i);
    if (val != null && val > maxScore) {
      maxScore = val;
      maxScoreIndex = i;
    }
  }

  assert(maxScoreIndex != -1);

  var indexes = <int>[maxScoreIndex];
  for (var y = needle.length - 2; y >= 0; y--) {
    var i = mIndexes.val(y, maxScoreIndex);
    assert(i != null);

    maxScoreIndex = i!;
    indexes.insert(0, maxScoreIndex);
  }
  // print(indexes);

  return FuzzySearchResult(maxScore, indexes);
}

const int int64MinValue = -9223372036854775808;
const int int16MinValue = -32768;
