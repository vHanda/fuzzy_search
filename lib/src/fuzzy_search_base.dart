import 'package:tuple/tuple.dart';

class _Matrix {
  List<int?> _value = [];
  int rows;
  int cols;

  // FIXME: Store this as a Int16List

  _Matrix({required this.rows, required this.cols}) {
    _value = List<int?>.filled(rows * cols, null);
  }

  // FIXME: This conversion to a List can be avoided!
  List<int?> row(int rowNum) {
    return _value.getRange(rowNum * cols, (rowNum + 1) * cols).toList();
  }

  int rowLength(int rowNum) => cols;

  int? val(int rowNum, int colNum) => _value[(rowNum * cols) + colNum];
  void setVal(int rowNum, int colNum, int val) {
    _value[rowNum * cols + colNum] = val;
  }

  void debugPrint(String base) {
    var str = base + '\n';

    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        var v = val(y, x);
        if (v != null) {
          str += v.toString();
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

  var prevMatchIndex = -1;

  for (var y = 0; y < needle.length; y++) {
    var needleChar = needle.codeUnitAt(y);
    var didMatch = false;

    for (var x = prevMatchIndex + 1; x < m.rowLength(y); x++) {
      var char = base.codeUnitAt(x);
      if (needleChar != char) {
        continue;
      }

      if (!didMatch) {
        didMatch = true;
        prevMatchIndex = x;
      }

      var score = 1;
      if (y > 0) {
        var maxPrevious = int64MinValue;
        var maxPreviousX = -1;
        for (var prevX = 0; prevX <= x - 1; prevX++) {
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

    if (!didMatch) {
      return null;
    }
  }

  // m.debugPrint(base);
  // mIndexes.debugPrint(base);

  var lastRow = m.row(needle.length - 1);
  var maxScore = int64MinValue;
  var maxScoreIndex = -1;
  for (var i = lastRow.length - 1; i >= needle.length - 1; i--) {
    final val = lastRow[i];
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

  return Tuple2<int, List<int>>(maxScore, indexes);
}

const int int64MinValue = -9223372036854775808;
const int int64MaxValue = 9223372036854775807;

const int int16MinValue = -32768;
const int int16MaxValue = 32767;
