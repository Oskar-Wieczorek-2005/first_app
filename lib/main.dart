import 'package:flutter/material.dart';
import 'repositories/pricing_repository.dart';
import 'repositories/cart.dart'; // Import the Cart class

//Hai Hai :3
void main() => runApp(const App());

enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'lib/assets/images/veggie_delight.png';
      case SandwichType.chickenTeriyaki:
        return 'lib/assets/images/chicken_teriyaki.png';
      case SandwichType.tunaMelt:
        return 'lib/assets/images/tuna_melt.png';
      case SandwichType.meatballMarinara:
        return 'lib/assets/images/meatball_marinara.png';
    }
  }
}

const normalText = TextStyle(fontSize: 18);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OrderScreen(),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart(); // Create a Cart instance
  int _quantity = 0;
  bool _isFootlong = true;
  BreadType _breadType = BreadType.white;
  SandwichType _sandwichType = SandwichType.veggieDelight; // Add sandwich type
  String _note = '';
  bool _isToasted = false;
  final int _maxQuantity = 5;

  final PricingRepository _pricingRepository = PricingRepository();

  void _increment() {
    if (_quantity < _maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    final sandwich = Sandwich(
      type: _sandwichType,
      isFootlong: _isFootlong,
      breadType: _breadType,
    );
    final pricePerItem = _pricingRepository.calculatePricePerItem(
      sandwich.type.name,
      _isFootlong,
    );
    final totalPrice = pricePerItem * _quantity; // Calculate total price
    _cart.addItem(
        sandwich, _quantity, _note, _isToasted, totalPrice); // Pass total price
    setState(() {
      _quantity = 0; // Reset quantity after adding to cart
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemType = _isFootlong ? 'footlong' : 'six-inch';
    final totalPrice =
        _pricingRepository.calculateTotalPrice(_quantity, itemType);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/logo.png', // Ensure this path is correct
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('Sandwich Counter'),
          ],
        ),
        centerTitle: false, // Aligns the title and logo to the left
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: _cart),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bread type dropdown
              DropdownButton<BreadType>(
                value: _breadType,
                onChanged: (value) {
                  setState(() {
                    _breadType = value ?? BreadType.white;
                  });
                },
                items: BreadType.values
                    .map((bread) => DropdownMenuItem<BreadType>(
                          value: bread,
                          child: Text(bread.name),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 10),

              // Sandwich type dropdown
              DropdownButton<SandwichType>(
                value: _sandwichType,
                onChanged: (value) {
                  setState(() {
                    _sandwichType = value ?? SandwichType.veggieDelight;
                  });
                },
                items: SandwichType.values
                    .map((type) => DropdownMenuItem<SandwichType>(
                          value: type,
                          child: Text(type.name),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 10),

              // Sandwich image display
              Image.asset(
                Sandwich(
                  type: _sandwichType,
                  isFootlong: _isFootlong,
                  breadType: _breadType,
                ).image, // Use the Sandwich.image getter
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 10),

              OrderItemDisplay(
                quantity: _quantity,
                itemType: itemType,
                breadType: _breadType,
                orderNote: _note.isEmpty ? 'No notes added.' : _note,
                isToasted: _isToasted,
              ),

              const SizedBox(height: 10),

              Text('Total Price: £${totalPrice.toStringAsFixed(2)}',
                  style: normalText),

              const SizedBox(height: 20),

              // Add / Remove buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    onPressed: _decrement,
                    icon: Icons.remove,
                    label: 'Remove',
                    backgroundColor: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  StyledButton(
                    onPressed: _increment,
                    icon: Icons.add,
                    label: 'Add',
                    backgroundColor: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sandwich size switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: (value) {
                      setState(() => _isFootlong = value);
                    },
                  ),
                  const Text('footlong', style: normalText),
                ],
              ),

              // Toasted switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('untoasted', style: normalText),
                  Switch(
                    value: _isToasted,
                    onChanged: (value) {
                      setState(() => _isToasted = value);
                    },
                  ),
                  const Text('toasted', style: normalText),
                ],
              ),

              // Notes input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  key: const Key('notes_textfield'),
                  decoration: const InputDecoration(labelText: 'Add a note'),
                  onChanged: (value) => setState(() => _note = value),
                ),
              ),

              ElevatedButton(
                onPressed: _quantity > 0 ? _addToCart : null,
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on SandwichType {
  String get image {
    String typeString = name;
    return 'assets/images/${typeString}.png'; // Adjust path as needed
  }
}

// Add a new screen to display the cart
class CartScreen extends StatelessWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text('${item.sandwich.name} x${item.quantity}'),
            subtitle: Text(
              '${item.sandwich.breadType.name}, ${item.sandwich.isFootlong ? 'Footlong' : 'Six-inch'}'
              '${item.isToasted ? ', Toasted' : ''}\nNote: ${item.note}',
            ),
            trailing: Text(
                '£${(item.totalPrice).toStringAsFixed(2)}'), // Display total price
          );
        },
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;
  final bool isToasted;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
    this.isToasted = false,
  });

  @override
  Widget build(BuildContext context) {
    final sandwiches = '🥪' * quantity;
    final toastedText = isToasted ? ' (toasted)' : ' (untoasted)';

    return Column(
      children: [
        Text(
          '$quantity ${breadType.name} $itemType sandwich(es): $sandwiches$toastedText',
          style: normalText,
        ),
        Text('Note: $orderNote', style: normalText),
      ],
    );
  }
}
