import 'dart:math';

/// The Levenshtein distance between two words is the minimum number of single-character
///
/// edits (insertions, deletions or substitutions) required to change one word into the other.
int getLevenshtein(String base, String query) {
  if (base.isEmpty) {
    return 30;
  }
  final a = base.toLowerCase();

  final b = query.toLowerCase();
  // i == 0
  final costs = List.filled(b.length + 1, 0);
  for (var j = 0; j < costs.length; j++) {
    costs[j] = j;
  }
  for (var i = 1; i <= a.length; i++) {
    // j == 0; nw = lev(i - 1, j)
    costs[0] = i;
    var nw = i - 1;
    for (var j = 1; j <= b.length; j++) {
      // ignore: omit_local_variable_types
      final int cj = min(
        1 + min(costs[j], costs[j - 1]),
        a[i - 1] == b[j - 1] ? nw : nw + 1,
      );
      nw = costs[j];
      costs[j] = cj;
    }
  }
  return costs[b.length];
}
