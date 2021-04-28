class Matrix {
  List<int?> _value = [];
  int rows;
  int cols;

  // FIXME: Store this as a Int16List

  Matrix({required this.rows, required this.cols}) {
    _value = List<int?>.filled(rows * cols, null);
  }

  // FIXME: This conversion to a List can be avoided!
  List<int?> row(int rowNum) {
    return _value.getRange(rowNum * cols, (rowNum + 1) * cols).toList();
  }

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
