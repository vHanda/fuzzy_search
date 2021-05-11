import 'matrix.dart';
import 'scoring.dart';

// the higher the score the better
class Result {
  int score;
  List<int> indexes;

  Result(this.score, this.indexes);
}

Result? fuzzySearch(String base, String needle) {
  // print('_fuzzySearchMatrix $base $needle');
  if (base.length < needle.length) {
    return null;
  }
  if (needle.isEmpty) {
    return Result(0, []);
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

      var score = 0;
      if (y > 0) {
        // Find the max value of the prev row
        var maxPrevious = int64MinValue;
        var maxPreviousX = -1;
        for (var prevX = prevMatchIndex; prevX <= x - 1; prevX++) {
          var s = m.val(y - 1, prevX);
          if (s == null) {
            continue;
          }

          var charScore = scoringFunc(
            hay: base,
            needle: needle,
            matchingChar: String.fromCharCode(char),
            posInNeedle: y,
            posInHay: x,
            prevMatchInHayIndex: prevX,
            prevMatchingChar: String.fromCharCode(base.codeUnitAt(prevX)),
            prevMatchScore: s,
          );
          var finalScore = s + charScore;
          if (finalScore >= maxPrevious) {
            maxPrevious = finalScore;
            maxPreviousX = prevX;
          }
        }
        score += maxPrevious;
        mIndexes.setVal(y - 1, x, maxPreviousX);
      } else {
        var firstCharScore = scoringFunc(
          hay: base,
          needle: needle,
          matchingChar: String.fromCharCode(char),
          posInNeedle: y,
          posInHay: x,
          prevMatchInHayIndex: -1,
          prevMatchingChar: '',
          prevMatchScore: 0,
        );
        score += firstCharScore;
      }
      m.setVal(y, x, score);
    }

    if (firstMatchIndex == null) {
      return null;
    } else {
      prevMatchIndex = firstMatchIndex;
    }
  }

  // m.debugPrint(base, needle);
  // mIndexes.debugPrint(base, needle);

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

  var indexes = List<int>.filled(needle.length, -1);
  indexes[needle.length - 1] = maxScoreIndex;

  for (var y = needle.length - 2; y >= 0; y--) {
    var i = mIndexes.val(y, maxScoreIndex);
    assert(i != null);

    maxScoreIndex = i!;
    indexes[y] = maxScoreIndex;
  }
  // print(indexes);

  return Result(maxScore, indexes);
}

const int int64MinValue = -9223372036854775808;
