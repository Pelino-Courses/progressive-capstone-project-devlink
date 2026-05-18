mixin Searchable {
  List<String> get searchKeywords;

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;

    final lowerQuery = query.toLowerCase();
    return searchKeywords.any(
      (keyword) => keyword.toLowerCase().contains(lowerQuery),
    );
  }
}