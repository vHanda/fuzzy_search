import 'package:fuzzy_search/fuzzy_search.dart';

class ComplexObj {
  final int a;
  final String b;

  ComplexObj(this.a, this.b);

  @override
  String toString() => 'ComplexObj($a, $b)';
}

void main() {
  var objects = [
    ComplexObj(10, 'bug optimistic chat not cleared out'),
    ComplexObj(20, 'Test optimistic bug'),
    ComplexObj(30, 'While bi-rotational editing'),
  ];

  var db = FuzzySearch<ComplexObj>(objects, mappingFn: (a) => a.b);
  var results = db.match('bit');
  for (var r in results) {
    print('${r.obj} ${r.score}');
  }
}
