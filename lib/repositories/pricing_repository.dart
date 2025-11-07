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
}
