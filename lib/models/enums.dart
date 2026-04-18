enum ProductCategory {
  clothes('Clothes'),
  shoes('Shoes'),
  accessories('Accessories');

  final String label;
  const ProductCategory(this.label);
}

enum ProductCondition {
  likeNew('Like New'),
  good('Good'),
  fair('Fair');

  final String label;
  const ProductCondition(this.label);
}