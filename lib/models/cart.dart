import '../repositories/pricing_repository.dart';
import '../main.dart'; // Contains Sandwich, BreadType, SandwichType

class Cart {
  final Map<Sandwich, int> _items = {};
  final PricingRepository _pricingRepository = PricingRepository();

  /// Returns an unmodifiable view of cart items.
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  /// True if cart has no items.
  bool get isEmpty => _items.isEmpty;

  /// Total number of sandwiches (sum of quantities).
  int get totalItems => _items.values.fold(0, (sum, qty) => sum + qty);

  /// Add a sandwich to the cart or increment its quantity.
  void addItem(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + 1;
    } else {
      _items[sandwich] = 1;
    }
  }

  /// Remove a sandwich entirely from the cart.
  void removeItem(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  /// Increment quantity of a sandwich.
  void increment(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + 1;
    }
  }

  /// Decrement quantity; removes the sandwich if quantity reaches 0.
  void decrement(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      final newQty = _items[sandwich]! - 1;
      if (newQty <= 0) {
        _items.remove(sandwich);
      } else {
        _items[sandwich] = newQty;
      }
    }
  }

  /// Remove all items from the cart.
  void clear() => _items.clear();

  /// Calculate total price using PricingRepository.
  double get totalPrice {
    double total = 0.0;
    _items.forEach((sandwich, qty) {
      final sizeStr = sandwich.isFootlong ? 'footlong' : 'six-inch';
      total += _pricingRepository.calculateTotalPrice(qty, sizeStr);
    });
    return total;
  }
}
