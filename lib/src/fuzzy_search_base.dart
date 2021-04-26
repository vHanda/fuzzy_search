List<int>? fuzzySearch(String base, String needle) {
  if (needle.isEmpty) {
    return [];
  }

  var indexes = <int>[];
  var remainder = String.fromCharCodes(needle.codeUnits);
  for (var i = 0; i < base.codeUnits.length; i++) {
    var char = base.codeUnits[i];
    if (char == remainder.codeUnits.first) {
      remainder = String.fromCharCodes(remainder.codeUnits, 1);
      indexes.add(i);
      if (remainder.isEmpty) {
        return indexes;
      }
    }
  }

  return null;
}
