import 'string_match.dart';

import 'package:diacritic/diacritic.dart';

typedef MapToStringFunction = String Function<T>(T t);

class FuzzySearch<T> {
  final List<T> list;
  final String Function(T t) mappingFn;

  FuzzySearch(this.list, {required this.mappingFn});

  List<FuzzySearchResult<T>> match(
    String needle, {
    bool ignoreCase = true,
    bool ignoreDiacritics = true,
  }) {
    var needleCleaned = needle;
    if (ignoreDiacritics) {
      needleCleaned = removeDiacritics(needleCleaned);
    }
    if (ignoreCase) {
      needleCleaned = needleCleaned.toLowerCase();
    }

    var results = <FuzzySearchResult<T>>[];
    for (var obj in list) {
      var hay = mappingFn(obj);
      if (ignoreDiacritics) {
        hay = removeDiacritics(hay);
      }
      if (ignoreCase) {
        hay = hay.toLowerCase();
      }

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
    results.sort((a, b) => b.score.compareTo(a.score));

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

extension FuzzyMatch on String {
  Result? fuzzyMatch(String needle) => fuzzySearch(this, needle);
}
