/// Product categories available in PreLoved Market.
enum ProductCategory {
  clothes('Clothes'),
  shoes('Shoes'),
  accessories('Accessories');

  final String label;
  const ProductCategory(this.label);
}

/// Condition rating for second-hand items.
enum ProductCondition {
  likeNew('Like New'),
  good('Good'),
  fair('Fair');

  final String label;
  const ProductCondition(this.label);
}