class PricingRepository {
  // Prices for different sandwich sizes
  final double sixInchPrice = 7.0;
  final double footlongPrice = 11.0;

  /// Calculates total price based on quantity and sandwich size.
  double calculateTotalPrice(int quantity, String sandwichType) {
    if (sandwichType == 'six-inch') {
      return quantity * sixInchPrice;
    } else if (sandwichType == 'footlong') {
      return quantity * footlongPrice;
    } else {
      throw ArgumentError('Invalid sandwich type: $sandwichType');
    }
  }

  double calculatePricePerItem(String sandwichType, bool isFootlong) {
    double basePrice;

    // Set base price based on sandwich type
    switch (sandwichType) {
      case 'veggieDelight':
        basePrice = 3.0;
        break;
      case 'chickenTeriyaki':
        basePrice = 4.5;
        break;
      case 'tunaMelt':
        basePrice = 4.0;
        break;
      case 'meatballMarinara':
        basePrice = 5.0;
        break;
      default:
        basePrice = 3.0; // Default price for unknown types
    }

    // Adjust price for footlong sandwiches
    return isFootlong ? basePrice * 1.5 : basePrice;
  }
}
