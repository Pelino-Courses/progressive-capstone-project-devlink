// utils.dart

// A1: Variables with types + null safety
int maxItems = 50;
String appName = "PreLoved Market";

var isAvailable = true;

final String currency = "RWF";
const double taxRate = 0.05;

// Null safety
String? optionalDescription;
String productName = "Shoes";

// Using ?? (default value)
String displayDescription = optionalDescription ?? "No description available";

// A2: Function with named parameters
String formatPrice({required int price, String currency = "RWF"}) {
  return "$price $currency";
}

// Optional parameter function
String greetUser(String name, [String? title]) {
  return title != null ? "$title $name" : name;
}

// Arrow function
int applyDiscount(int price) => (price * 0.9).toInt();


// A3: Collections

// List
List <String> categories = ["Shoes", "Jackets", "T-Shirts"];

// Map
Map<String, int> productPrices = {
  "Shoes": 8000,
  "Jacket": 15000,
};

// Set (no duplicates)
Set<String> sizes = {"S", "M", "L", "XL"};


// A4: Control flow

// if/else
String checkCondition(String condition) {
  if (condition == "new") {
    return "Brand New";
  } else if (condition == "used") {
    return "Used";
  } else {
    return "Unknown Condition";
  }
}

// switch
String getCategoryMessage(String category) {
  switch (category) {
    case "Shoes":
      return "Find the best shoes!";
    case "Jackets":
      return "Stay warm in style!";
    default:
      return "Browse items";
  }
}

// ternary operator
String getAvailability(bool isAvailable) {
  return isAvailable ? "Available" : "Out of Stock";
}


// Async example (for Part B preview)
Future<String> fetchProducts() async {
  await Future.delayed(Duration(seconds: 2));
  return "Products loaded";
}