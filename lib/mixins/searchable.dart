/// Mixin that adds search capability to any model.
/// Classes using this mixin must provide [searchKeywords]
/// which returns a list of strings to match against.
mixin Searchable {
  /// Returns a list of keywords that this item can be searched by.
  List<String> get searchKeywords;

  /// Checks if this item matches the given [query].
  /// Uses case-insensitive partial matching against all keywords.
  bool matchesSearch(String query) {
    // A4: Control flow — early return for empty query
    if (query.isEmpty) return true;

    final lowerQuery = query.toLowerCase();

    // A3: List usage — iterating through keyword list
    return searchKeywords.any(
      (keyword) => keyword.toLowerCase().contains(lowerQuery),
    );
  }
}