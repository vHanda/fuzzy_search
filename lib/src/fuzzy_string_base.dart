import 'string_match.dart';

typedef MapToStringFunction = String Function<T>(T t);

class FuzzySearch<T> {
  final List<T> list;
  final MapToStringFunction mappingFn;

  FuzzySearch(this.list, {required this.mappingFn});

  List<FuzzySearchResult<T>> match(String needle) {
    var results = <FuzzySearchResult<T>>[];
    for (var obj in list) {
      var hay = mappingFn(obj);
      var r = fuzzySearch(hay, needle);
      if (r == null) {
        continue;
      }
      results.add(FuzzySearchResult(
        obj: obj,
        score: r.score,
        indexes: r.indexes,
      ));
    }

    return results;
  }
}

class FuzzySearchResult<T> {
  final T obj;
  final int score;
  final List<int> indexes;

  FuzzySearchResult({
    required this.obj,
    required this.score,
    required this.indexes,
  });
}
