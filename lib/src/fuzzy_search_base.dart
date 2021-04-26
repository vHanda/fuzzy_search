bool fuzzySearch(String base, String needle) {
  if (needle.isEmpty) {
    return true;
  }

  var remainder = String.fromCharCodes(needle.codeUnits);
  for (var char in base.codeUnits) {
    if (char == remainder.codeUnits.first) {
      remainder = String.fromCharCodes(remainder.codeUnits, 1);
      if (remainder.isEmpty) {
        return true;
      }
    }
  }

  return false;
}
