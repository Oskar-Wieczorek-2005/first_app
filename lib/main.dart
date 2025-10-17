import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final List<String> descriptions;

  const OrderItemDisplay(this.quantity, this.descriptions, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$quantity sandwich(es): ${'🥪' * quantity}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          if (descriptions.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: descriptions
                  .asMap()
                  .entries
                  .map((entry) => Text(
                        'Sandwich ${entry.key + 1}: ${entry.value}',
                        style: const TextStyle(color: Colors.white70),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  final List<String> _descriptions = [];
  final TextEditingController _descriptionController = TextEditingController();
  double _sandwichTypeValue = 1; // 0 = Six-inch, 1 = Footlong

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        final type = _sandwichTypeValue == 1 ? 'Footlong' : 'Six-inch';
        final noteText = _descriptionController.text.trim();
        _descriptions
            .add('[$type] ${noteText.isEmpty ? "(No note)" : noteText}');
        _quantity++;
        _descriptionController.clear();
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        _descriptions.removeLast();
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(_quantity, _descriptions),
            const SizedBox(height: 16),
            Column(
              children: [
                Text(
                  _sandwichTypeValue == 1 ? 'Footlong' : 'Six-inch',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _sandwichTypeValue,
                  min: 0,
                  max: 1,
                  divisions: 1,
                  label: _sandwichTypeValue == 1 ? 'Footlong' : 'Six-inch',
                  onChanged: (value) {
                    setState(() {
                      _sandwichTypeValue = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Type your order note before adding a sandwich',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _quantity >= widget.maxQuantity
                      ? null
                      : _increaseQuantity,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  icon: const Icon(Icons.remove),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
