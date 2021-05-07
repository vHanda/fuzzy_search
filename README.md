# Fuzzy Search

[![CI](https://img.shields.io/github/workflow/status/vhanda/fuzzy_search/Dart%20CI)](https://github.com/vHanda/fuzzy_search/actions?query=Dart%20CI)


Fuzzy search is typically used to search a large list of file names by typing
a few relevant characters. Such as Quick Open in VSCode or Sublime.

Unlike classical [fuzzy string matching](https://en.wikipedia.org/wiki/Approximate_string_matching) which
matches strings which approximately match (implemented by Fuse.js). The matching here requires the
matching characters to exist one after another at some point in the string.

Example -

```
source/string.dart
source/test/regression/graph.dart
sour/strinf.dart
```

When searching for `string`, only the first two strings match. The matching characters are indicated in uppercase -

```
source/STRING.dart
Source/Test/RegressIoN/Graph.dart
```

This library implements the algorithm explained in [these wonderful posts](https://www.objc.io/blog/2020/08/18/fuzzy-search/).

## Example

```dart
  var list = [
    'source/string.dart',
    'source/test/regression/graph.dart',
    'sour/strinf.dart',
  ];
  for (var l in list) {
    var r = l.fuzzyMatch('string');
    if (r == null) {
      continue;
    }

    var cp = l;
    for (var index in r.indexes) {
      var char = String.fromCharCode(cp.codeUnitAt(index));
      cp = cp.replaceRange(index, index + 1, char.toUpperCase());
    }

    print('${r.score} $l -> $cp');
  }
```


For automatic diacritics and case-removal look at the API in example.
