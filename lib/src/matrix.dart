class Matrix {
  List<int?> _value = [];
  int rows;
  int cols;

  Matrix({required this.rows, required this.cols}) {
    _value = List<int?>.filled(rows * cols, null);
  }

  int? val(int rowNum, int colNum) => _value[(rowNum * cols) + colNum];
  void setVal(int rowNum, int colNum, int val) {
    _value[rowNum * cols + colNum] = val;
  }

  void debugPrint(String base, String needle) {
    var str = '  ' + base + '\n';

    for (var y = 0; y < rows; y++) {
      str += String.fromCharCode(needle.codeUnitAt(y));
      str += ' ';

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
