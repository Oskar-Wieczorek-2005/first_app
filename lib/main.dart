import 'package:flutter/material.dart';
import 'repositories/pricing_repository.dart';

void main() => runApp(const App());

enum BreadType { white, wheat, wholemeal }

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
  int _quantity = 0;
  bool _isFootlong = true;
  BreadType _breadType = BreadType.white;
  String _note = '';
  bool _isToasted = false;
  final int _maxQuantity = 5;

  // 💰 Pricing repository instance
  final PricingRepository _pricingRepository = PricingRepository();

  void _increment() {
    setState(() {
      if (_quantity < _maxQuantity) {
        _quantity++;
      }
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemType = _isFootlong ? 'footlong' : 'six-inch';
    final totalPrice = _pricingRepository.calculateTotal(
      isFootlong: _isFootlong,
      quantity: _quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sandwich size switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  key: const Key('type_switch'),
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
                  key: const Key('toasted_switch'),
                  value: _isToasted,
                  onChanged: (value) {
                    setState(() => _isToasted = value);
                  },
                ),
                const Text('toasted', style: normalText),
              ],
            ),

            const SizedBox(height: 20),

            // Bread type dropdown
            DropdownMenu<BreadType>(
              initialSelection: _breadType,
              onSelected: (BreadType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _breadType = newValue;
                  });
                }
              },
              dropdownMenuEntries: BreadType.values
                  .map(
                    (BreadType type) => DropdownMenuEntry<BreadType>(
                      value: type,
                      label: type.name,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            // Order display
            OrderItemDisplay(
              quantity: _quantity,
              itemType: itemType,
              breadType: _breadType,
              orderNote: _note.isEmpty ? 'No notes added.' : _note,
              isToasted: _isToasted,
            ),

            const SizedBox(height: 10),

            // 💷 Total price
            Text(
              'Total price: £${totalPrice.toStringAsFixed(2)}',
              style: normalText,
            ),

            const SizedBox(height: 20),

            // Add / Remove buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _decrement,
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red.shade300,
                ),
                const SizedBox(width: 10),
                StyledButton(
                  onPressed: _increment,
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green.shade400,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Notes input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                key: const Key('notes_textfield'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add a note',
                ),
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
            ),
          ],
        ),
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
    final toastedText = isToasted ? 'toasted' : 'untoasted';
    return Column(
      children: [
        Text(
          '$quantity ${breadType.name} $itemType sandwich(es) ($toastedText): $sandwiches',
          style: normalText,
        ),
        Text('Note: $orderNote', style: normalText),
      ],
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
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
