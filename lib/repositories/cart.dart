import '../main.dart'; // Import Sandwich and related enums

class CartItem {
  final Sandwich sandwich;
  final int quantity;
  final String note;
  final bool isToasted;
  final double totalPrice;

  CartItem({
    required this.sandwich,
    required this.quantity,
    required this.note,
    required this.isToasted,
    required this.totalPrice,
  });
}

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(Sandwich sandwich, int quantity, String note, bool isToasted) {
    if (quantity <= 0) return;

    final existingItemIndex = _items.indexWhere((item) =>
        item.sandwich.type == sandwich.type &&
        item.sandwich.isFootlong == sandwich.isFootlong &&
        item.sandwich.breadType == sandwich.breadType &&
        item.isToasted == isToasted &&
        item.note == note);

    if (existingItemIndex != -1) {
      // Update quantity if the item already exists
      final existingItem = _items[existingItemIndex];
      _items[existingItemIndex] = CartItem(
        sandwich: existingItem.sandwich,
        quantity: existingItem.quantity + quantity,
        note: existingItem.note,
        isToasted: existingItem.isToasted,
        totalPrice: existingItem.totalPrice +
            (existingItem.totalPrice / existingItem.quantity) * quantity,
      );
    } else {
      // Add a new item to the cart
      final pricePerItem = sandwich.isFootlong ? 5.0 : 3.0; // Example pricing
      _items.add(CartItem(
        sandwich: sandwich,
        quantity: quantity,
        note: note,
        isToasted: isToasted,
        totalPrice: pricePerItem * quantity,
      ));
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
  }

  void clear() {
    _items.clear();
  }

  double get totalCost => _items.fold(0, (sum, item) => sum + item.totalPrice);
}
