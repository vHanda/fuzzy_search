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
  final conseqMatch = numUnmatchedChars == 0;

  // 1 point for maching a char
  var score = 1;

  // First letter match
  if (prevMatchInHayIndex == -1) {
    assert(posInNeedle == 0);
    // score += hay.length - posInHay;
    // return score;
  } else {
    score -= (numUnmatchedChars * 2);
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
  }

  // Each consequtive match should give us a lot
  /*
  if (conseqMatch) {
    var numConseqMatches = 1;
    var prev = prevMatchInHayIndex;
    for (var prevMatchIndex in prevIndexes) {
      if (prev - prevMatchIndex == 1) {
        numConseqMatches++;
        prev = prevMatchIndex;
      } else {
        break;
      }
    }

    score += numConseqMatches;
  }
  */

  if (conseqMatch) {
    score += 1;
  }

  return score;
}

// I think we need examples for this

// FIXME: Expose an iterator for all the prev scores and positions? Is this required?