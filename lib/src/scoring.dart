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
  required String prevMatchInHayChar,
  required int prevMatchScore,
}) {
  // 1 point for maching a char
  var score = 1;

  // First letter match
  if (prevMatchInHayIndex == -1) {
    // score += hay.length - posInHay;
    return score;
  }

  var gapPenalty = (posInHay - prevMatchInHayIndex) - 1;
  score -= gapPenalty;
  return score;

  // If we match at the start of a word, that should count for a lot
  // start of a word is identified by -
  //   0 index
  //   last char is a space

  // Each consequtive match should give us a lot
}

// I think we need examples for this
