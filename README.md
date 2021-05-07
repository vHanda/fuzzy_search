Fuzzy search is typically used to search a large list of file names by typing
a few relevant characters. Example - Quick Open in VSCode or Sublime. The algorithm implemented
is very similar to

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
