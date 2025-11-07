class PricingRepository {
  final double sixInchPrice;
  final double footlongPrice;

  PricingRepository({
    this.sixInchPrice = 7.0,
    this.footlongPrice = 11.0,
  });

  double calculateTotal({
    required bool isFootlong,
    required int quantity,
  }) {
    final pricePerSandwich = isFootlong ? footlongPrice : sixInchPrice;
    return pricePerSandwich * quantity;
  }
}
