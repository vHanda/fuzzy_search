/// Return the score for this position
/// The final score will be all of the scores added
/// prevMatchScore is the total score from start to prevMatch
int scoringFunc({
  required String hay,
  required String needle,
  required String matchingChar,
  required int posInNeedle,
  required int posInHay,
  required int prevMatchInHayIndex,
  required String prevMatchingChar,
  required int prevMatchScore,
  required Iterable<int> prevIndexes,
}) {
  final numUnmatchedChars = (posInHay - prevMatchInHayIndex) - 1;

  // void debugPrint(String reason, int amount, int finalScore) {
  //   print('   ($matchingChar) $reason: $amount -> $finalScore');
  // }

  // 1 point for maching a char
  var score = 1;

  // First letter match
  if (prevMatchInHayIndex == -1) {
    assert(posInNeedle == 0);
    // score += hay.length - posInHay;
    // return score;
  } else {
    score -= (numUnmatchedChars * 2);
    // print('PosInHay: $posInHay prevMatchInHayIndex: $prevMatchInHayIndex');
    // debugPrint('Unmatched chars', numUnmatchedChars * -2, score);
  }

  // If we match at the start of a word, that should count for a lot
  // start of a word is identified by -
  //   0 index
  //   last char is a space
  var isStartOfWord = posInHay == 0;
  if (!isStartOfWord) {
    var prevChar = String.fromCharCode(hay.codeUnitAt(posInHay - 1));
    if (prevChar == ' ') {
      isStartOfWord = true;
    }
  }

  if (isStartOfWord) {
    score += 5;
    // print('pos in Hay $posInHay');
    // debugPrint('Start of word', 5, score);
  }

  // Each consequtive match should give us a lot
  var numConseqMatches = 0;
  var prev = posInHay;
  for (var prevMatchIndex in prevIndexes) {
    if (prev - prevMatchIndex == 1) {
      numConseqMatches++;
      prev = prevMatchIndex;
    } else {
      break;
    }
  }
  if (numConseqMatches > 0) {
    if (numConseqMatches == 1) {
      score += 5;
    } else {
      score += numConseqMatches;
    }
    // score += numConseqMatches + 5;
    // debugPrint('Conseq Char', numConseqMatches + 5, score);
  }

  // debugPrint('FinalScore', 0, score);

  return score;
}
